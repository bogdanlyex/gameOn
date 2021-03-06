<%--
  User: bogdan
  Date: 2/5/14
  Time: 8:12 PM
--%>
<%@ include file="/jsp/common/include.jsp" %>
<jsp:include page="/jsp/common/init.jsp"/>
<c:set var="product" value="${sessionScope.product}"/>
<script type="text/javascript">
Ext.define('Comment', {
    extend: 'Ext.data.Model',
    fields: [
        'id',
        'comment'
    ],
    idProperty: 'id'
});


Ext.onReady(function () {
    var background, banner, productDetailsPanel, commentsPanel, commentForm,
            commentsGrid, commentStore;

    banner = new Ext.panel.Panel({
        minHeight: 100,
        layout: 'column',
        items: [
            {
                columnWidth: 0.90
            }
            <c:choose>
            <c:when test = "${not empty loggedUser}">
            ,
            new Ext.form.Panel({
                title: 'User information',
                minWidth: 200,
                bodyPadding: 1,
                url: appPath + '/logout',
                items: [
                    {
                        xtype: 'displayfield',
                        fieldLabel: 'Welcome',
                        value: '${loggedUser.userBean.username}'
                    }
                ],
                buttons: [
                    {
                        text: 'Sign out',
                        handler: function () {
                            var form = this.up('form').getForm();
                            if (form.isValid()) {
                                form.submit({
                                    success: function (form, action) {
                                        window.location = appPath + '/index';
                                    },
                                    failure: function (form, action) {

                                    }
                                });
                            }
                        }
                    }
                ]
            })
            </c:when>
            <c:otherwise>
            ,
            new Ext.form.Panel({
                title: 'Sign in',
                bodyPadding: 1,
                url: appPath + '/authentication',
                defaultType: 'textfield',
                items: [
                    {
                        fieldLabel: 'Username',
                        name: 'username',
                        allowBlank: false
                    },
                    {
                        fieldLabel: 'Password',
                        inputType: 'password',
                        name: 'password'

                    }
                ],

                buttons: [
                    {
                        text: 'Sign in',
                        formBind: true,
                        disabled: true,
                        handler: function () {
                            var form = this.up('form').getForm();
                            if (form.isValid()) {
                                form.submit({
                                    success: function (form, action) {
                                        window.location = appPath + '/index';
                                    },
                                    failure: function (form, action) {

                                    }
                                });
                            }
                        }
                    },
                    {
                        text: 'Sign up',
                        handler: function () {
                            window.location = appPath + '/createAccount';
                        }
                    }
                ]
            })
            </c:otherwise>
            </c:choose>
        ]
    });

    productDetailsPanel = new Ext.form.Panel({
        title: 'Product details',
        minHeight: 500,
        items: [
            {
                xtype: 'displayfield',
                fieldLabel: 'Product name',
                value: '${product.productName}'
            },
            {

                xtype: 'displayfield',
                fieldLabel: 'Price',
                value: '${product.price}'
            },
            {
                xtype: 'displayfield',
                fieldLabel: 'Category',
                value: '${product.category.categoryName}'
            },
            {
                xtype: 'displayfield',
                fieldLabel: 'Brand',
                value: '${product.brand.brandName}'
            },
            {
                xtype: 'image',
                src: '${product.bannerLink}'
            },
            {
                xtype: 'displayfield',
                fieldLabel: 'Description',
                value: '${product.description}'
            },
            {
                xtype: 'toolbar',
                layout: 'column',
                items: [
                    {
                        xtype: 'tbseparator',
                        columnWidth: 0.4
                    },
                    {
                        text: 'Back',
                        columnWidth: 0.1,
                        minWidth: 50,
                        handler: function () {
                            window.location = appPath + '/index';
                        }
                    },
                    {
                        xtype: 'tbseparator',
                        columnWidth: 0.4
                    }
                ]
            }
        ]
    });

    commentForm = new Ext.form.Panel({
        url: appPath + '/comment/save',
        items: [
            {
                xtype: 'textareafield',
                name: 'comment',
                fieldLabel: 'Comment'
            }
        ],
        buttons: [
            {
                text: 'Save',
                handler: function () {
                    var form = this.up('form').getForm();
                    if (form.isValid()) {
                        form.submit({
                            success: function (form, action) {
                                window.location = appPath + '/getPage?productId=${product.id}';
                            },
                            failure: function (form, action) {

                            }
                        });
                    }
                }
            }
        ]
    });

    commentStore = Ext.create('Ext.data.Store', {
        model: 'Comment',
        proxy: {
            type: 'ajax',
            url: appPath + '/comments/list.json',
            reader: {
                type: 'json',
                totalProperty: 'totalRecords',
                idProperty: 'id',
                root: 'records'
            },
            writer: {
                type: 'json',
                encode: true
            }
        },
        autoLoad: true
    });

    commentsGrid = new Ext.grid.GridPanel({
        store: commentStore,
        columns: [
            {
                header: 'Comment',
                flex: 1,
                dataIndex: 'comment',
                align: 'center',
                sortable: false
            }
        ],
        minHeight: 400,
        maxHeight: 500
    });

    commentsPanel = new Ext.panel.Panel({
        title: 'Comments',
        items: [
            <c:if test="${not empty loggedUser}">
            commentForm,
            </c:if>
            commentsGrid
        ]
    });

    background = new Ext.panel.Panel({
        minHeight: 1000,
        renderTo: Ext.getBody(),
        bodyStyle: {
            backgroundColor: "gray"
        },
        layout: {
            type: 'vbox',
            align: 'stretch',
            padding: 10
        },
        items: [
            banner, productDetailsPanel, commentsPanel
        ]
    });

})
;
</script>