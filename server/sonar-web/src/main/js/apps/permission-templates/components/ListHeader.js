/*
 * SonarQube
 * Copyright (C) 2009-2017 SonarSource SA
 * mailto:info AT sonarsource DOT com
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
import React from 'react';

export default class ListHeader extends React.PureComponent {
  static propTypes = {
    permissions: React.PropTypes.array.isRequired
  };

  render() {
    const cells = this.props.permissions.map(p => (
      <th key={p.key} className="permission-column">
        {p.name}
        <i className="icon-help little-spacer-left" title={p.description} data-toggle="tooltip" />
      </th>
    ));

    return (
      <thead>
        <tr>
          <th>&nbsp;</th>
          {cells}
          <th className="thin nowrap text-right">&nbsp;</th>
        </tr>
      </thead>
    );
  }
}
