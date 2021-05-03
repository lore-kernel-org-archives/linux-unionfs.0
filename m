Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FAEC433ED
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 May 2021 18:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B5161029
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 May 2021 18:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhECSt6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 May 2021 14:49:58 -0400
Received: from mx-relay42-hz2.antispameurope.com ([94.100.136.242]:51445 "EHLO
        mx-relay42-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhECSt6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 May 2021 14:49:58 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 14:49:57 EDT
Received: from smtp-out.all-for-one.com ([91.229.168.76]) by mx-relay42-hz2.antispameurope.com;
 Mon, 03 May 2021 20:43:54 +0200
Received: from bruexc105.brumgt.local (10.251.3.41) by bruexc106.brumgt.local
 (10.251.3.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2176.2; Mon, 3 May 2021
 20:43:51 +0200
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (10.251.3.124) by
 bruexc105.brumgt.local (10.251.3.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2176.2
 via Frontend Transport; Mon, 3 May 2021 20:43:51 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwQgtTQMENqJxIhMQWRsm7P5anjQgUVgxuFoFAOets7FrO9CawSfoXOpWH0sbugjGGQYR12cWtRgbEyWGY61xUdSSbRC35iZeIy27XBhVcYh5Zd6uwF88apOTGZN7kv4E1+b/Z55EcVixq4ECjRGxjCwcrKeIzCzokPqSthcIWu/FR/+FfpRJLlSyFJlkM4GWyy/1Jci2etRWoe4FOMA+MpaojwvKJYohHO0zVIXv+NhQ2RHLftoKAR+R/SkvUqswfRxp3vYB3xVCvuLdb+uwy9rtKdBDHahoYr/YYeLtuJ23iyxShRtMYdvo3l0yOgrCnPmIA+fyini7yMApkTOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuAXVPaaaRwYf1kJgZ4tEPwa+Sg3TRtnZZ3P5vI4pMY=;
 b=nYZxy82/a0UEopt4tCAJhi5BNavTsXVzqhRwDAzGCmi/4Jf0n5f6s5wVFo5Z0kgKR/FQER05aerXfNVguJB/kx9XESHpaw2GOL6dnJt7vLPYsaER7FOuZ0D4seKfR4vjgSOrDvJcLvTr1v6Uhe/hyDUhiI6sK0U0OEpibICyNnuZ6HaEVPnPADdr+76oWRKfBtzuKhy1OZYQ/Ih02lvJAUFLfx89u/QmpMXwnagk8g+294qeNQggdG0XDM3rX+w8GK7/HCJpxDOoRwWl+/tMXEk6PUSNo4oUmfpDlatWZ17MPxvhSYTEQfjoq6PsCZCF7xA9RSlT9QHzEhOMHFEBag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bruker.com; dmarc=pass action=none header.from=bruker.com;
 dkim=pass header.d=bruker.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Bruker.onmicrosoft.com; s=selector2-Bruker-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuAXVPaaaRwYf1kJgZ4tEPwa+Sg3TRtnZZ3P5vI4pMY=;
 b=gS/L8CN5GMmiUEMSIdE+IDKGwNIxUC/iZG9s0Bkk+SSwkU1dSfLVuhcBVMn0EQQblETUAoWfpDJYxFJRt/USaaeNADT3idGUF2UBJi7z9oqWIJxlHEncUTeI7JrGdO/Q2jYEWP6TZvoTGNr39n3ZYq6b1bYARlOH72uiX139xa8=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=bruker.com;
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ef::11)
 by AM4PR1001MB1266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Mon, 3 May
 2021 18:43:51 +0000
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::1558:a0b3:abc2:cae5]) by AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::1558:a0b3:abc2:cae5%4]) with mapi id 15.20.4087.043; Mon, 3 May 2021
 18:43:51 +0000
From:   Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH] ovl: do not set overlay.opaque for new directories
Date:   Mon,  3 May 2021 20:42:58 +0200
Message-Id: <20210503184258.96714-1-Vyacheslav.Yurkov@bruker.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2.205.7.42]
X-ClientProxiedBy: FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::9) To AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:1ef::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from uvv-2004-vm.localdomain (2.205.7.42) by FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Mon, 3 May 2021 18:43:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d68a996c-6b75-4866-385d-08d90e6364ff
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB12663D003A248EBAC23D2CB7865B9@AM4PR1001MB1266.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oYeFeh7LslFnYVYdqdEvJspeji92yJyX6SUh/g9r1yh1LJ2WuYgCrFSxuNOVWnyv+P1ADnYLic3q8eCxsAyaxi7m+AsYj3wQxBqOIZK2O7Evxm7KE6ym0Uy4RBtrPVLgj0R7xZXFjR0XltxQbal6spkN6O5JT2THAyEaKi3FEM9Uc6AoaRL1TdIEJwtHtBNOtV8PbZ17iPymHGWNhUfvRigVSmaBaDf9Z9h65X25jXTi5LfLW2/xmSrZWtFVGPqaeDfttRSv8IbtspSHZdnMWiaxWxpdwjSqjv3asAE6U3E1oMWEqHfc5lFJvm05dxCcbU1tjp98HeFciBczZg2+ybhFdCiIJ+6ao8HGjGMIbUMmGjAA/OA4/LlVOA1T9u9WxstLkFlJf4zR/eRwqLmI6c0OKjV1BLf3KDtYyBU3xpfg3TBhal/qPnvHknqYvazEpvuvbsyqYecd7ynI3HhVc9OXP1VfEj0lU6g6sUjbb+gOtnHpRILTtvmpjAZpoSGqSZjxGdbdMvZzzQHkJO365NGg/UVJRKWMs4+ZMQGoMngtvo+TtF1paRqdEayaPx/Qj0LxHGEw0S31yA1rrlIneCFSiYTIsyfKKju2dH0mibMB8oiKJ5OnFOHdryH5R2aGgDm9GnyeD4/ocJwOnP0WkB3sbiEmLPGU4FGdDmYJ8eSn6Krzj2lxsB6kfVDGohGd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(136003)(366004)(376002)(2616005)(5660300002)(86362001)(956004)(54906003)(316002)(26005)(16526019)(186003)(8936002)(8676002)(107886003)(6506007)(6486002)(38100700002)(2906002)(4326008)(6512007)(1076003)(66476007)(66946007)(38350700002)(83380400001)(36756003)(478600001)(52116002)(66556008)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Edmw6fm417OTEzYkiPB1HvCo6Yw8WJGTRmER8NSgG2QlnZq+Ps0ZUsrdCPMt?=
 =?us-ascii?Q?nRCZnZbMLuE1ERwvDEA2lgYlFo2721+7Hfjj66vOAXZ5xgWFtVKXPtK6t5KP?=
 =?us-ascii?Q?bzjUD/S634LzpGjRC23pWyA70MFcwXrSqJdRCuZmkHg/LCUnstIqp6+PXubD?=
 =?us-ascii?Q?vH8KTTZiObcGs89KLvj0HIOtAHCO2Ql0qYoItU/893Bjf+c98d6nLejv78+d?=
 =?us-ascii?Q?HJjbH7ntRk7Z9KImRN95e02+ohlp2wPkR6vh5SScXJsJx9UOBdf1R88Q+xxN?=
 =?us-ascii?Q?spHSFfKyJtenOBmlipXM6pMV3ahKP62jeNPe0R+XkQQRriR63NxY5TlbZ6Eh?=
 =?us-ascii?Q?0LrrGCCFQPChZ9wiM1tt4F0NMYdaxcWryhDnJEF+lcQ9kWLmw0+0mhe6zXok?=
 =?us-ascii?Q?EY89ibaSXklObdl3TDeG/logQnuSVxiYuDpf4Mi5xnzImqBIcIbMVM/nEvCg?=
 =?us-ascii?Q?l1cG7LgpORBEMf8igqP/iFN2l/en0GnoxvwuX1NDTMc3jm8fkDV+FQr7kvRc?=
 =?us-ascii?Q?wgX8IhtD8yduNT040JNfoI7Hf0UCLcJqbyfCWVa3+t4YJ1GyTcvRfsm5EcgS?=
 =?us-ascii?Q?QeZKgVQlZprj3WRLOuwwfJtgd0LWXDnUq9TAoZ4/JyIPOQ40uXr8nFJmKka4?=
 =?us-ascii?Q?OdKYwKglqBCQxVt54/Ygx6yj6CiNF/6ul19RapCmM3WCpzbXgh8ZS4jmRvZw?=
 =?us-ascii?Q?ORSkBejvG8QKWIEQJPFmefc7SQiZ6HOASIA2NwaTtL2SsZWkQ9ccQTdh56fx?=
 =?us-ascii?Q?NOYdw9G8JPVEfRlCPwflhqWmjJKlHMcls5pE6dHQgLwZc5DipXIbMlO064YF?=
 =?us-ascii?Q?iDKx+eij//5247bvi6H6i/+QBDCayX8UezT9g4BKLdGQDlAVWFdAPeViggve?=
 =?us-ascii?Q?UE/anDYFW+OEidinAXe2cPWEYuk6KkiK4lkV1JJ13dOQ3RchM4dGFhKIzL/7?=
 =?us-ascii?Q?1kBfNCw5wwhdHw5oqjHV7S+xYzvZmzyVYMDoFzMPx5bVED2ZZ8aPoTOkMttI?=
 =?us-ascii?Q?Behd6pw4xnczPgdOaAUmuaRDw2JU+ZrnK5N3Wea5n2bir6FRpOdXCKLuEwuo?=
 =?us-ascii?Q?rppj0vDNigmfAk9y6LYmH40ea8G4aiQx/wgOiL29fVAKPVSvXnLdcxDfhC6p?=
 =?us-ascii?Q?SP/kk66bIRFuBnwcdl6l+9yQ2q75Cyw5DerCe21CSIVvI5Q05WaSYhUWDB8z?=
 =?us-ascii?Q?8kQBO66v/8y2jiHDLhtaQAsxs8vQaWegkMU9g+lVtbBEB/JqBDDGdsa0FvFs?=
 =?us-ascii?Q?FR+LcgaTiyIWmV8jzUE1wK0LOVwR3UqPL4j5jWh8WO5hbIhgtB4g3xDoE1TW?=
 =?us-ascii?Q?vPb218eD0qdvjI195nlJfDXn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d68a996c-6b75-4866-385d-08d90e6364ff
X-MS-Exchange-CrossTenant-AuthSource: AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 18:43:50.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 375ce1b8-8db1-479b-a12c-06fa9d2a2eaf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNdD+bP7NPoD42tTW3NY8GERKjBboRScSoUhlmFsrgOV+fueMuA1A1bu5cVuKWkn4UUniL/VDV7OfzR9NfsTHvA9oEvzsxDAMWncyzixwWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1266
X-OriginatorOrg: bruker.com
X-cloud-security-sender: vyacheslav.yurkov@bruker.com
X-cloud-security-recipient: linux-unionfs@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay42-hz2.antispameurope.com with 078EC1221D76
X-cloud-security-connect: smtp-out.all-for-one.com[91.229.168.76], TLS=1, IP=91.229.168.76
X-cloud-security-Digest: 48485e0e59f0916d97236132d6142d92
X-cloud-security: scantime:1.342
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This optimization breaks existing use case when a lower layer directory
appears after directory was created on a merged layer. If overlay.opaque
is applied, new files on lower layer are not visible.

Consider the following scenario:
- /lower and /upper are mounted to /merged
- directory /merged/new-dir is created with a file test1
- overlay is unmounted
- directory /lower/new-dir is created with a file test2
- overlay is mounted again

If opaque is applied by default, file test2 is not going to be visible
without explicitly clearing the overlay.opaque attribute

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/dir.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 93efe7048a77..f66f96dd9f0c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -338,11 +338,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(newdentry))
 		goto out_unlock;
 
-	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
-		/* Setting opaque here is just an optimization, allow to fail */
-		ovl_set_opaque(dentry, newdentry);
-	}
-
 	err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
 	if (err)
 		goto out_cleanup;
-- 
2.25.1

