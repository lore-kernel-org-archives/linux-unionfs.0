Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E59AC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D086E206DC
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="K4CgNGOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgFDVeM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 17:34:12 -0400
Received: from mail-vi1eur05on2119.outbound.protection.outlook.com ([40.107.21.119]:64320
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbgFDVeL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 17:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/P/sY54UBnrO8a9IVJAAcbUFTg075jh9hazco4J3ohMsAsvScFxwzBe05n9QtSHnPKtH6bk10b2L58kyw4GSSwGUUSf9jOOI5aSlQIASxuhk+7E9GTb3LKawkqajvoA8KPo+PUc6ds9FNHFC3C2gVjCRBdGAM/FxL+LdcCWDXqioBhhICLMduG+iU+DqNn0YiBxI5vqAac711067jWLVYEZFFwtbqG0fBe2GOH+keiQeZd2mYiTloZVK/LmHbe9yF/ZxH+PZAiL4mg8wHy1C6oO6/0oChQIiHRRma6gjC/CWUtxQvoaYB3912cr9JqVS/rrDBrnC/vkDLgIL8SRuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgxJuGdE6CJNi48F8TxWf7wgRd2tn/ONuAdeWGe9qBk=;
 b=IXTSrXs3swEZ/0UDFJeh3ujSVqrPjikx+Slg5cN/kxSzxobc+PeNw53lYswElkJeX9jedCcetvE6mRp1tiA4NFrUykwqro5K8LXrqNNNQNzkie4pQOHVvRoH23jqguC8eH1YmRoPSmd0YcHTBIteybgTiaCu8vkgCPyUaGLYsnx3HO/F4O/i22q4Hb0srkZS3fK88/YdtLur6BLAHFauR2X+AO9669BhYdAzwOo7+s89iwDF0JRVncZxRpaG1fay6UgpFWsuYd+6+IDwas5ko3ccE4N45Dsi7ooHQai3JVBJ/DwTFbCN21v+MNwKY/A1GXXsAhcs8kHCCkWKOOswsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgxJuGdE6CJNi48F8TxWf7wgRd2tn/ONuAdeWGe9qBk=;
 b=K4CgNGOAiUpQhRlEiA1oPLU6bU6CAh3oVh7oTAhcp0veVvOZQ4OqA6hgV9S0wsF2+tQfhFQbHhhir9hVurfD62FTZcc2tATiERsTqN4wy6gLn+kFpYzqyJqxR7rFSRNg8o9fk8z4qHesA2cf13wfKbNShBHyXLQpoY2pGhztk+Q=
Received: from AM6PR08MB3639.eurprd08.prod.outlook.com (2603:10a6:20b:51::33)
 by AM6PR08MB3351.eurprd08.prod.outlook.com (2603:10a6:209:48::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 21:34:07 +0000
Received: from AM6PR08MB3639.eurprd08.prod.outlook.com
 ([fe80::f9f3:ebdb:2a53:c2d7]) by AM6PR08MB3639.eurprd08.prod.outlook.com
 ([fe80::f9f3:ebdb:2a53:c2d7%7]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 21:34:07 +0000
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
Thread-Topic: [PATCH 0/2] overlayfs: C/R enhancements
Thread-Index: AQHWOosBznFYrKt2fUuocLUlO0auLajIwDoAgAAt+xQ=
Date:   Thu, 4 Jun 2020 21:34:07 +0000
Message-ID: <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>,<CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=virtuozzo.com;
x-originating-ip: [91.76.135.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0f82c1a-3fcb-481f-d91e-08d808cf0318
x-ms-traffictypediagnostic: AM6PR08MB3351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR08MB3351247805EF3C1138EFCBDCE8890@AM6PR08MB3351.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9KfR/dGBRQxQl8r93VLNFDJpKQiK8MOQXJPBoQGwVyqd/i9qzIbuI57D5zG4nLrJhIw1zWtWwbrNCV+11B/fdbGQ4L4/y2yC/+W6qQ5b8zhtd5v4A7GOZB4C7w/ZJVm2eBFj47QP87G5zeMMaTglYN1SKfbqDFR54MEswQYpNFOmUgMc/T93XLTqhB7HeAeVDoC9QGdKnXy2WUGp1xwaZD3Tw5h68s+ZezePYTtemJrY5Skfhxcr/qWoEnQJ2ky7c8XRQFVb0pOGI2MwiHx3yWt6h8gkoe/ERZ9tQhAzGUG1biZXvLRnoj7Q9oDhbqBOJ7EPkqG1UCn71Lsds5IJfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3639.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(39850400004)(366004)(53546011)(33656002)(83380400001)(8936002)(478600001)(54906003)(66446008)(9686003)(7696005)(55016002)(86362001)(76116006)(66476007)(6506007)(66556008)(64756008)(8676002)(66946007)(186003)(4326008)(6916009)(316002)(2906002)(5660300002)(71200400001)(52536014)(44832011)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jDt6SEhc8nTY9zXi4OjqWHv8dxakAgNGzOQKRAFiFCx6OaRP+cMr2WtHJlu04AfLKXZhCIFcmPay46+EwGpK6baBJwUXaTYBMk08DaNrsR6XbmJVRmLBRoZtCnsbTseBOe1jvoMwRCIYDNazyTbZ23WZOywqO2Oeo9koZsQuqKeNzGmL5y2HEWp03DJDGPk4KxtV7/yI+ojSTngQQFRN87dO9BUmq6hPr40o4wMQWVyD6flmiufynqWa4x/avriLMyvYxDy7vTXHbmkO9Pc+taw+hlXkFtLsn/k2rq6bcgXN2DzslgjUF7XMsxuQqFI78Goju1TDCa67SDwD7Kopj4huunZ8QGS0QmaI5/H7HsCedLzQ1b8YjQjXaY5OTyyn6i5fahjL1f9COdwAqOMy772B0o2dbzuqLcBJcj8hcqigQNuMRgjucDd5+xRTkfO/BhMUCaqJtdPLOjjWvMjezer/TC2HD/hc1TGQtIwT+yE=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f82c1a-3fcb-481f-d91e-08d808cf0318
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 21:34:07.4888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSiyjT2ZaLizWWWOl29jjoiSQKrhfRa9u+OaBZtCbDSxRPCsytpcx9ms8tdr0OmJhXe7l/0F7nrcCL+ptcuKJJsCsDU69/VvGwZOQLHF0dngZc3ZhwIrjXjxykZI0Z2E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3351
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

>But overlayfs won't accept these "output only" options as input args,
which is a problem.

Will it be problematic if we simply ignore "lowerdir_mnt_id" and "upperdir_mnt_id" options in ovl_parse_opt()?

>Wouldn't it be better for C/R to implement mount options
that overlayfs can parse and pass it mntid and fhandle instead
of paths?

Problem is that we need to know on C/R "dump stage" which mounts are used on lower layers and upper layer. Most likely I don't understand something but I can't catch how "mount-time" options will help us.

>I believe C/R is using a similar method to export inotify/fanotify
marks.

Yes, we are using fhandles to C/R inotify/fanotify. On "dump" we get fhandle from /proc/<pid>/fdinfo and on "restore" we open fhandle through open_by_handle_at() syscall.

Regards, Alex

________________________________________
From: Amir Goldstein <amir73il@gmail.com>
Sent: Thursday, June 4, 2020 21:04
To: Alexander Mikhalitsyn
Cc: Miklos Szeredi; Andrey Vagin; Pavel Tikhomirov; Konstantin Khorenko; Vasiliy Averin; Kirill Tkhai; overlayfs; linux-kernel
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements

On Thu, Jun 4, 2020 at 7:13 PM Alexander Mikhalitsyn
<alexander.mikhalitsyn@virtuozzo.com> wrote:
>
> This patchset aimed to make C/R of overlayfs mounts with CRIU possible.
> We introduce two new overlayfs module options -- dyn_path_opts and
> mnt_id_path_opts. If enabled this options allows to see real *full* paths
> in lowerdir, workdir, upperdir options, and also mnt_ids for corresponding
> paths.
>
> This changes should not break anything because for showing mnt_ids we simply
> introduce new show-time mount options. And for paths we simply *always*
> provide *full paths* instead of relative path on mountinfo.
>
> BEFORE
>
> overlay on /var/lib/docker/overlay2/XYZ/merged type overlay (rw,relatime,
> lowerdir=/var/lib/docker/overlay2/XYZ-init/diff:/var/lib/docker/overlay2/
> ABC/diff,upperdir=/var/lib/docker/overlay2/XYZ/diff,workdir=/var/lib/docker
> /overlay2/XYZ/work)
> none on /sys type sysfs (rw,relatime)
>
> AFTER
>
> overlay on /var/lib/docker/overlay2/XYZ/merged type overlay (rw,relatime,
> lowerdir=/var/lib/docker/overlay2/XYZ-init/diff:/var/lib/docker/overlay2/
> ABC/diff,upperdir=/var/lib/docker/overlay2/XYZ/diff,workdir=/var/lib/docker
> /overlay2/XYZ/work,lowerdir_mnt_id=175:175,upperdir_mnt_id=175)
> none on /sys type sysfs (rw,relatime)
>

But overlayfs won't accept these "output only" options as input args,
which is a problem.

Wouldn't it be better for C/R to implement mount options
that overlayfs can parse and pass it mntid and fhandle instead
of paths?
I believe C/R is using a similar method to export inotify/fanotify
marks.

FWIW overlayfs already has utilities that encode filehandle to
text and back, see  ovl_get_index_name().

Thanks,
Amir.
