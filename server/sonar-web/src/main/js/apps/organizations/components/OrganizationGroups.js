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
// @flow
import React from 'react';
import { connect } from 'react-redux';
import init from '../../groups/init';
import { getOrganizationByKey } from '../../../store/rootReducer';
import type { Organization } from '../../../store/organizations/duck';

class OrganizationGroups extends React.PureComponent {
  props: {
    organization: Organization
  };

  componentDidMount() {
    init(this.refs.container, this.props.organization);
  }

  render() {
    return <div ref="container" />;
  }
}

const mapStateToProps = (state, ownProps) => ({
  organization: getOrganizationByKey(state, ownProps.params.organizationKey)
});

export default connect(mapStateToProps)(OrganizationGroups);
