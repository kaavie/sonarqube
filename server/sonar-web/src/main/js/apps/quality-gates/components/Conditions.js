/*
 * SonarQube
 * Copyright (C) 2009-2016 SonarSource SA
 * mailto:contact AT sonarsource DOT com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import _ from 'underscore';
import React from 'react';
import uniqBy from 'lodash/uniqBy';

import ConditionsAlert from './ConditionsAlert';
import AddConditionForm from './AddConditionForm';
import Condition from './Condition';
import { translate } from '../../../helpers/l10n';

function getKey (condition, index) {
  return condition.id ? condition.id : `new-${index}`;
}

export default function Conditions (
    {
        qualityGate,
        conditions,
        metrics,
        periods,
        edit,
        onAddCondition,
        onSaveCondition,
        onDeleteCondition
    }
) {
  const sortedConditions = _.sortBy(conditions, condition => {
    return metrics.find(metric => metric.key === condition.metric).name;
  });

  const duplicates = [];
  conditions.forEach(condition => {
    const sameCount = conditions
        .filter(sample => sample.metric === condition.metric && sample.period === condition.period)
        .length;
    if (sameCount > 1) {
      duplicates.push(condition);
    }
  });

  const uniqDuplicates = uniqBy(duplicates, d => d.metric)
      .map(condition => {
        const metric = metrics.find(metric => metric.key === condition.metric);
        return { ...condition, metric };
      });

  return (
      <div id="quality-gate-conditions" className="quality-gate-section">
        <h3 className="spacer-bottom">
          {translate('quality_gates.conditions')}
        </h3>

        <ConditionsAlert/>

        {uniqDuplicates.length > 0 && (
            <div className="alert alert-warning">
              <p>{translate('quality_gates.duplicated_conditions')}</p>
              <ul className="list-styled spacer-top">
                {uniqDuplicates.map(d => (
                    <li>{d.metric.name}</li>
                ))}
              </ul>
            </div>
        )}

        {sortedConditions.length ? (
            <table id="quality-gate-conditions" className="data zebra zebra-hover">
              <thead>
                <tr>
                  <th className="nowrap">
                    {translate('quality_gates.conditions.metric')}
                  </th>
                  <th className="thin nowrap">
                    {translate('quality_gates.conditions.leak')}
                  </th>
                  <th className="thin nowrap">
                    {translate('quality_gates.conditions.operator')}
                  </th>
                  <th className="thin nowrap">
                    {translate('quality_gates.conditions.warning')}
                  </th>
                  <th className="thin nowrap">
                    {translate('quality_gates.conditions.error')}
                  </th>
                  {edit && <th></th>}
                </tr>
              </thead>
              <tbody>
                {sortedConditions.map((condition, index) => (
                    <Condition
                        key={getKey(condition, index)}
                        qualityGate={qualityGate}
                        condition={condition}
                        metrics={metrics}
                        periods={periods}
                        edit={edit}
                        onSaveCondition={onSaveCondition}
                        onDeleteCondition={onDeleteCondition}/>
                ))}
              </tbody>
            </table>
        ) : (
            <div className="big-spacer-top">
              {translate('quality_gates.no_conditions')}
            </div>
        )}

        {edit && (
            <AddConditionForm metrics={metrics} onSelect={onAddCondition}/>
        )}
      </div>
  );
}
