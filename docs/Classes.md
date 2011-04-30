Classes
=======

#### Index
{file:README.md Readme}
{file:docs/Installation.md Installation}
{file:docs/Usage.md Usage}
{file:docs/Architecture.md Architecture}
{file:docs/AdditionalServices.md Additional Services}
{file:docs/Classes.md Classes}

{Kangaroo}
--------

### Railtie
* {Kangaroo::Railtie}

### Model
* {Kangaroo::Model}
* * {Kangaroo::Model::Attributes}
* * {Kangaroo::Model::Base}
* * {Kangaroo::Model::ConditionNormalizer}
* * {Kangaroo::Model::DefaultAttributes}
* * {Kangaroo::Model::Field}
* * {Kangaroo::Model::Finder}
* * {Kangaroo::Model::Inspector}
* * {Kangaroo::Model::OpenObjectOrm}
* * {Kangaroo::Model::Persistence}
* * {Kangaroo::Model::ReadonlyAttributes}
* * {Kangaroo::Model::Relation}
* * {Kangaroo::Model::RemoteExecute}

### RubyAdapter
* {Kangaroo::RubyAdapter}
* * {Kangaroo::RubyAdapter::Base}
* * {Kangaroo::RubyAdapter::ClassDefinition}
* * {Kangaroo::RubyAdapter::Fields}

### Util
* {Kangaroo::Util}
* * {Kangaroo::Util::Client}
* * {Kangaroo::Util::Configuration}
* * {Kangaroo::Util::Database}
* * {Kangaroo::Util::Loader}
* * * {Kangaroo::Util::Loader::Model}
* * * {Kangaroo::Util::Loader::Namespace}
* * * {Kangaroo::Util::Loader::RootNamespace}
* * {Kangaroo::Util::Proxy}
* * * {Kangaroo::Util::Proxy::Common}
* * * {Kangaroo::Util::Proxy::Db}
* * * {Kangaroo::Util::Proxy::Object}
* * * {Kangaroo::Util::Proxy::Report}
* * * {Kangaroo::Util::Proxy::Superadmin}
* * * {Kangaroo::Util::Proxy::Wizard}
* * * {Kangaroo::Util::Proxy::Workflow}

### Hirb
* {Hirb::Views::Kangaroo}

### Exceptions
* {Kangaroo::Exception}
* * {Kangaroo::RecordNotFound}
* * {Kangaroo::ReadonlyRecord}
* * {Kangaroo::RecordSavingFailed}
* * {Kangaroo::InstantiatedRecordNeedsIDError}
* * {Kangaroo::ChildDefinedBeforeParentError}
* * {Kangaroo::NoMethodError}