Return-Path: <SRS0=fTQB=DU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E62C43457
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7308248B3
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="V+SwD6ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgJMPAw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 11:00:52 -0400
Received: from mail-db8eur05on2137.outbound.protection.outlook.com ([40.107.20.137]:29537
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbgJMPAv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Oct 2020 11:00:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9u++kaFq6s3TtqXz7br4zEHdydmKsJZo7jn3KY49hJhQHScVy2M5zXDC5V1260FR+m9JH+kyT0jrZmYyB3xp9G357WYTiwCXIEPnPCeDPnuliVi0Fxdys1uVmZfXqXCzo8bMML38EAAaYxe9PrWBnHzLBIuG+lp4zV1tumW6wnjZvHzlXgEfPzMxR5piuv8L84rV+oe9Jjyu9KPY2d03BJ3M0t3hNZPwhTOJ+K1BWquvM8V5xHMNHfG/HQpdvzePaOZcv7n/Nqk9huQ283Qe6ERQkf5i9ooC6Iaq7rjwEctKo/l5T9c9V+q/j8nuGBQX7sYz3ptQW/CqLs/AdK+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbjJGr/SiuQiMnRZymR5UrW5v4ekiPqfT/sKeccbV4I=;
 b=k1Zr77/mr49X5KN7XPQIXJD8AD6400XLB+xh9Vrc8HVuiKI9Ae+Otw1WlXtwwMeIqnTrYG9zHy6fO1rUVptdAdvxpXOA7N7GKeDMX66+NdWp6dwUqbbC27gDfIaEJ1vV4tK8glO60+RNh16StB0k9V0myc3aCWgTYor6jmqsFlx3LVOKlI4Xk+fY3thyfOXr2u5bEo76vX+46FXSMBfSuHX/dW4qAtqE+i2a11dG1LOWBbxRtIYh4Ui+Is3RZoQrpLEllTr9llM69pGN43KYmcYbZTFueEXkZ6g9UayGpbbKoSkjK2ouyqgwUp3ZIpMhsC6Wzi+Y9tPOZ9NjBHAU/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbjJGr/SiuQiMnRZymR5UrW5v4ekiPqfT/sKeccbV4I=;
 b=V+SwD6ez0eL2Ud525UoF1mtQe3ey239iLFGgHg5Bey7RXEZ0YtAZvQy1qqGNq4K0yeumogSE7YlpKfEyI32vlV6HJIyPTHwMlZi4/xbbPJF+/okZaHCA5MZ0ztnua5xGW6ZI37UE5qGbWbbalid3VxKgW2/bTRY085jsxOLaPQc=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AS8PR08MB6184.eurprd08.prod.outlook.com (2603:10a6:20b:29c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.29; Tue, 13 Oct
 2020 15:00:48 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4%5]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 15:00:48 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] ovl introduce "uuid=off"
Date:   Tue, 13 Oct 2020 17:59:52 +0300
Message-Id: <20201013145954.4274-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [46.39.230.109]
X-ClientProxiedBy: AM0PR04CA0132.eurprd04.prod.outlook.com
 (2603:10a6:208:55::37) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (46.39.230.109) by AM0PR04CA0132.eurprd04.prod.outlook.com (2603:10a6:208:55::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Tue, 13 Oct 2020 15:00:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2db57e7-67c9-4dcf-14bc-08d86f88c480
X-MS-TrafficTypeDiagnostic: AS8PR08MB6184:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB61840D9B1A567A35B56780B0B7040@AS8PR08MB6184.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X14tJLIiqRE4fnysrQtMl5BNgik7FlnTbhEe3UEhKdeUgEzz04PWEDZEx+KUzUhmhNN5Hj3cQhUfYAt2vOCEnL/Gh5JSxdhqUY+RiXb0Judr/EBATPkc4Du5876WtNKaZpTv2h2x3ZLTFdVG3NVOwY2LoyEMVPYmDPUVMCYr0cCi8TqNqrPulRmI1MgugNATAO1dX2g4hBd4ZygPNyy4ultpfdUNY1QYOKm0nW1g+Gmnm9EwZo3jAaqEH0f3FPfqKF7e1OAiGFutBnvR1rUEkI2PTWHE7haOQ/8zTPqvOtNnrlVIBQvazMVsLSUQKPhmvSwP+m6bXGht/KojEtIStZSdda/sacTBZO2sNTT7/2XCF3nIEwUA5C2maMhK8bJT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(366004)(396003)(136003)(346002)(186003)(52116002)(26005)(1076003)(316002)(2906002)(6916009)(54906003)(6512007)(66476007)(66946007)(16526019)(6666004)(66556008)(69590400008)(4326008)(36756003)(83380400001)(2616005)(956004)(478600001)(8936002)(8676002)(86362001)(6506007)(6486002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bebeF986c/f+FQERfXT0mXlZ2V6QqTsvkhp2LRr1K/9dhmiyrzCnAs8wJlI8oTlDwvmIdAqiache1ZuH+KlXbL3MkavkUV31xeNI/I2I4ju/bvQQYdFSrSzW7tEyEl9lrQWg4hK78tpUHGqm2pYrXyPssFsb+KW1/VPv8pIKO73Dk5JHjl3UourZEyVJa4qxm5QOJwVYvdATeUDQC3HQETnL0xdmvmL5J1+1NGUzAXYklfvyiEv/x+tgv1UHobY/CgwQM9PBmka4sy4muJVC5+PPLhQDDj8j/FKBuApo6ESszajYwM0dL4tQKyB4XgJJYq4YXRHP7As59fBRCsDXK4GAJvpEQCv6w4w8TXGSYoxprJklMDNMIoBgijOTQ4xlsJn4qrIKoKh9wbdtfs8afG3f4k4nB6DkeuWp2qe+RzQJ9C8Z2LT0UZSp6lzH+dRodKx0qV+8HbGMUedKMlQqDRkx1cPkconeU2UG0D76EY9YPo7MJyPDvyg0pGl3lrqiSB1LiObaQiR0kE/wBaAnIN5RiBYNTNGNoLE2YfkXmTQx2CrONcifHcaw0RkU1VgUA7DmlZVo7NqWAi82acQRuI1GdOiV3S9/Lb6mrRQ44Qf+wxKSfIYdghvrvSXbgcuMXV1zhicsIELbPiRDKvutgg==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2db57e7-67c9-4dcf-14bc-08d86f88c480
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 15:00:48.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijs6fghQAY+2JtOq9U2dCg1E31Ohz7tbsj5CVDvOjblGSOE9UPpfn27GILVDrVLLz8JLDdvt1fQwBBlPbgk0eNQeF/Ar6VjNWsyza2hN4/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6184
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a v5 of:
ovl: introduce new "index=nouuid" option for inodes index feature

Changes in v3: rebase to overlayfs-next, replace uuid with null in file
handles, propagate ovl_fs to needed functions in a separate patch, add
separate bool "uuid=on/off" option, fix numfs check fallback, add a note
to docs.

Changes in v4: get rid of double negatives, remove nouuid leftower
comment, fix missprint in kernel config name.

Changes in v5: fix typos; remove config option and module param.

Amir, as second patch had changed quiet a bit, I don't add you
reviewed-by to it.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (2):
  ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
  ovl: introduce new "uuid=off" option for inodes index feature

 Documentation/filesystems/overlayfs.rst |  5 +++++
 fs/overlayfs/copy_up.c                  | 25 ++++++++++++++-----------
 fs/overlayfs/export.c                   | 10 ++++++----
 fs/overlayfs/namei.c                    | 23 +++++++++++++----------
 fs/overlayfs/overlayfs.h                | 14 ++++++++------
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 20 ++++++++++++++++++++
 fs/overlayfs/util.c                     |  3 ++-
 8 files changed, 69 insertions(+), 32 deletions(-)

-- 
2.26.2

