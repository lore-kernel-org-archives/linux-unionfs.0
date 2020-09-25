Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D255C4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B77E20888
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="kdhskfTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgIYIfp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:35:45 -0400
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:60481
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYIfp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 04:35:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E35XtRwctuZi3pesfaWg+pRssrPM3RH84NtEJlj0raNRwxCnp13dyQEXR5+uuoqoMwPA/0uKihNnAcrUdNMrZJVvXck+bijPD5/xQQtV69Uh2C74Oo4NcHS75e3x3TY4XJyb8FJ5Qm1YeO6svP26hAALASoJSKz3flf4L5zY2Q/MADApl1A8bv9KsbJ7T/wjYLizalcvYVXNN2/eKcYOTpBXjZVE91N3sSrrCyCxXfvkHUQ5X3PzI4SfKoNCXsRmXMgxR85s9wxszsJiBwoWyciDPKZIQgrpGWkdiyaE9yFokuPsw6hPthzueFJGDshBLYqyrh+RWmEXbz/XVjFZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otd5qFyj48fMJ+kGAQYZsGTNsUXLdb4sQJsg0R3vPEo=;
 b=cHhihAHaJ2Ylm178WsT4oSgKLba2byU4erBFDL0TUDzv1sRK1jw3oqDhPJOpDQIrZ8oUajKI/NDegYbxs11Kzxik9s7Qq4jmagphlYYg761u4sIXCD5QmAj6MAmNsqEF+h0n29BNhAy7cIHV+j4uj8+MJwY1WO836SZTvSRLnIiCz5Wc44kS4yDyMXzI7ucckg9vNuaaPlKuxmxKD32Q/hqHsU1/m2s4KgETCG2pVBPRS9AMS2gWOCazYYvGqh7BiyxNxOLbssOwjA37j4T6clKLITA44OXCgQAojkcfFGBJQ/c16yaW3plullD2JHGxIikYwV8xeIarmv9hDt5Zsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otd5qFyj48fMJ+kGAQYZsGTNsUXLdb4sQJsg0R3vPEo=;
 b=kdhskfTOuIrs1Y09pFliXmm/VBgQrSIGf0c3OuUbXH6jVAu1nnqUtVWUIPoXT43CbP4ylos142yZkW8QVdaNY3FNcxZXX7q8TS3P4BJwbRIvID9wAq5PSWQ+ksmHBXovvx6rn99sTl0eGJinuQXO6IzD63ZDEKPDrheuy2SHQXA=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3333.eurprd08.prod.outlook.com (2603:10a6:209:45::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 25 Sep
 2020 08:35:35 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 08:35:35 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] ovl introduce "uuid=off"
Date:   Fri, 25 Sep 2020 11:35:05 +0300
Message-Id: <20200925083507.13603-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:208:136::27) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from snorch.sw.ru (95.179.127.150) by AM0PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:208:136::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 08:35:34 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fe0f759-a44f-4179-b902-08d8612df911
X-MS-TrafficTypeDiagnostic: AM6PR08MB3333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB33331857CA61111334337D85B7360@AM6PR08MB3333.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwK4cEI2/FMF9cTlKvaWOBaYc1L0k04+XQvShxxt76kBaEQI6CvmxB+9zsNoxgjjmvPn5pnXb1GxSSTj0Y0zJtMHeTwm5++6SCZBFwALDa/tZPck93KIS1e4UswFvFKhwhAVCWMvq6n14mg9kE8E1yN/LU4Ck6F1t/yQiryEtk1xjJaw477La/EjMQfON0Z+l1uPuBu74fTjsjVHGuCv1J+jjmIZpPj5XHbi6ifNRCyLljJHNwWfpYqzWs0mFAgUhL7q7jzxuVtHKKnE1TFUxMPQJZHkNBAtkAW2ygKQHl+2vv8D5tbuylw/Y9a1LAnMsm+lCAAI6JAmYCCHYvqaIIg6U7SWzq9UeUv1fRKEfEiFEcg+aLnSUv9ggjvmlok3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(186003)(36756003)(66946007)(8676002)(86362001)(16526019)(956004)(66556008)(6916009)(8936002)(2906002)(66476007)(316002)(5660300002)(6486002)(2616005)(1076003)(6512007)(4326008)(83380400001)(54906003)(478600001)(6506007)(52116002)(6666004)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Xh0g/uaX7uFyJGDglySeuyjnT4fK3cxXkEGCS1n1NawrJC5TY2bvZ7bkCEXT46G/fqNyTjP0UJjLN+6AVhrniGFvSl2xfBgb3M7+jPmj3Jpx7c5vy4B4i1VThNTX4y2TdAYdIB2BxXB12Zx1phXgApcOPdu12mdiY8TAVwAs2ucKC3P5BrUW18n3W3tiAZ+DJ4Gd8UzW1zLGN3GezTMAchgDhi0zrnUME2nz0JKX9zfZ+KKxa0k/6BdE5m7QCUqwdjq1sGNaZ8+czIg4x84tH42SPq3crHNYTYUiypi4xCuoJZ0pVFawE8PPXv3UeMx2VNG+AK2UzYPPDsFN2k9MPrBJSxEgCHkI6r1E370bt6DX0T5vzzWjlQrneu9D8o14fR8rIMdLpFbGHF3oTkGnqflPpmu2Z3IddHvfdHEij51odK33vOdA3cG6zQ5ZrM0Q+Fb/Tj4gGszf9dZGJdHQgnc2gV+J049tG/rgQZmUqlSCVIgYWpPbh+qBBvm3WoDFNeYPaj+IXVhXaQA7VC7pggpwxgE85sBG8nFS4TCYZXNtISTb3goUg+xznhc7v8SBeG8Mf/9XFhPbnM5rY9oghG52PXRPhRFQoLiUDLh8QJEr13sTuY1Nka+BRXuS1ZetWGasRaXaZhP9lJaTrBeRZw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe0f759-a44f-4179-b902-08d8612df911
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 08:35:35.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XY4eH+TWpWzVSQdCr9eygCJXRnHZ1oQvMUWjQ+TDfNd7IBV7luj1fAHnS9h5kbVvdCdTkPL3swHQ6jl3WA5Qcgn3fOJunpYtXtTTs3VBz9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3333
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a v4 of:
ovl: introduce new "index=nouuid" option for inodes index feature

Changes in v3: rebase to overlayfs-next, replace uuid with null in file
handles, propagate ovl_fs to needed functions in a separate patch, add
separate bool "uuid=on/off" option, fix numfs check fallback, add a note
to docs.

Changes in v4: get rid of double negatives, remove nouuid leftower
comment, fix missprint in kernel config name.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (2):
  ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
  ovl: introduce new "uuid=off" option for inodes index feature

 Documentation/filesystems/overlayfs.rst |  6 ++++++
 fs/overlayfs/Kconfig                    | 19 +++++++++++++++++++
 fs/overlayfs/copy_up.c                  | 25 ++++++++++++++-----------
 fs/overlayfs/export.c                   | 10 ++++++----
 fs/overlayfs/namei.c                    | 23 +++++++++++++----------
 fs/overlayfs/overlayfs.h                | 14 ++++++++------
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
 fs/overlayfs/util.c                     |  3 ++-
 9 files changed, 94 insertions(+), 32 deletions(-)

-- 
2.26.2

