json.partial! 'organizations/organization', organization: @organization
json.partial! 'branches/branch', collection: @organization.branches, as: :branch
