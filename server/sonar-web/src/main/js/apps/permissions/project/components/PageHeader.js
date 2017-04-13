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
import { connect } from 'react-redux';
import { translate } from '../../../../helpers/l10n';
import ApplyTemplateView from '../views/ApplyTemplateView';
import { loadHolders } from '../store/actions';
import { isPermissionsAppLoading } from '../../../../store/rootReducer';

class PageHeader extends React.PureComponent {
  static propTypes = {
    project: React.PropTypes.object.isRequired,
    loadHolders: React.PropTypes.func.isRequired,
    loading: React.PropTypes.bool
  };

  static defaultProps = {
    loading: false
  };

  componentWillMount() {
    this.handleApplyTemplate = this.handleApplyTemplate.bind(this);
  }

  handleApplyTemplate(e) {
    e.preventDefault();
    e.target.blur();
    const { project, loadHolders } = this.props;
    const organization = project.organization ? { key: project.organization } : null;
    new ApplyTemplateView({ project, organization })
      .on('done', () => loadHolders(project.key))
      .render();
  }

  render() {
    const configuration = this.props.project.configuration;
    const canApplyPermissionTemplate = configuration != null &&
      configuration.canApplyPermissionTemplate;

    const description = ['VW', 'SVW'].includes(this.props.project.qualifier)
      ? translate('roles.page.description_portfolio')
      : translate('roles.page.description2');

    return (
      <header className="page-header">
        <h1 className="page-title">
          {translate('permissions.page')}
        </h1>

        {this.props.loading && <i className="spinner" />}

        {canApplyPermissionTemplate &&
          <div className="page-actions">
            <button className="js-apply-template" onClick={this.handleApplyTemplate}>
              Apply Template
            </button>
          </div>}

        <div className="page-description">
          {description}
        </div>
      </header>
    );
  }
}

const mapStateToProps = state => ({
  loading: isPermissionsAppLoading(state)
});

const mapDispatchToProps = (dispatch, ownProps) => ({
  loadHolders: projectKey => dispatch(loadHolders(projectKey, ownProps.project.organization))
});

export default connect(mapStateToProps, mapDispatchToProps)(PageHeader);
