Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BB8C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 16:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjKNQI5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 11:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjKNQI4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 11:08:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B5A12C
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 08:08:52 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEFPPFm029538;
        Tue, 14 Nov 2023 16:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=1MdbFcPd2lnSIfofap5PvpmKQEBnFf2/yPWSazs8g9w=;
 b=GdvHKkjjIUr/gMG6KnZ+RxOpNKuf9rSIjyFbbtVWcWOsv/IkkbQ4dmkSAE5mkx1ieO1b
 Lio4EyzXpQVU45n/kJ1MPHfuxk4PUk1pc0Yj3/fxFWY73NHKVxkd7KwV8IlAxpXdrfLw
 kfhK8smxeMCJicUnXcCjFX8aT21GuXO+sx5p6V1T8MgKiaqghp+N9bn4WTLHJfTzgk3H
 BZQWn3JhJyPfwdVdTVdiQEuSzNDxtFKjw5Vw0bPDdgIkkGvma1hI9xVsfL0yhwL5Ndui
 SmC3zS2IOVwRcDlzxCADAgJzJV3CbYCsdOOL0Lx09iGnomfH9TavMGYrhaTGgoqC2d/g CQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2r060se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 16:08:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEG4ofu003989;
        Tue, 14 Nov 2023 16:08:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj28820-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 16:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXzWjxi0wqxwJm3eiKEY146cvjxu15iKLWfiYFDONKVoy9l1+VkgRM9TAaNiwYtLaBnavDbFereMPtZe76xuCtoeEgJhNOIjq9QpwuhdWx358rB5GXKGcW+gGJ4rjbJ8WoJdUSOm3GLCOAU76hdD3W0tGVjvk99DbUDAkXBwKAiz/5H1FvN1BPtX4lmH52+9DW38i1aZzaALPfNdm8OhDKgIijS92dh1SKXUyVcOOjNiszTxnpBJZPqD2PEtFOuAGUIdGE8DZMmelko6J1b8UxC4+80ssJZ3hNkShnRBErURaPGnAwRxqiHjN8wgDmmPLrsMfGQ2YhqXG9l99pIS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MdbFcPd2lnSIfofap5PvpmKQEBnFf2/yPWSazs8g9w=;
 b=mLSmnA9zSzjStCnX/dEuhfC/R7R/pDKbdWwzJY/PYfiQBaCnjzemkthrZzEqZf2CZZHBafb8iHGxC1hMi5CMkmsaz9xP+ewna9o0OO7iS6rdqzm2kB6CycW5/UVwB8TGp6TnwmfG6BPbOXcPigKaUpmOwE68dD8UiKM/PVA2z5bdwgUu6paFn4Am5oE43SNewqtb4k1CeauBq9InWAD+vR+o6o+epniUEwuFIwj4h5pXJ8S1SdBOVi4Ii2oSZPCu1UxIzuZ79iegLijItUMChDBR7nTwcnccIaDFms76LOl4g0fNEqNmDc2+hk/CNmW8tjJ4TC+jDwcslpIjYlJyxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MdbFcPd2lnSIfofap5PvpmKQEBnFf2/yPWSazs8g9w=;
 b=Oy8G20C/YCvwYtviyAufxIpAoAZR+jPMJ2g7N0de1GwpfAYhQikGla5HVT1DZadw23KSLZb77UPIIsxMZrgMP5pk/8uoxe15VnrPWW5XWEO+pAVqcsPpo/gv7aGZsIUjzarr0tt/aw9BBq6DP+PorBzhI76H6oMbno+iBLd1bWY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6312.namprd10.prod.outlook.com (2603:10b6:510:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 16:08:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::360b:b3c0:c5a9:3b3c]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::360b:b3c0:c5a9:3b3c%4]) with mapi id 15.20.7002.015; Tue, 14 Nov 2023
 16:08:44 +0000
Date:   Tue, 14 Nov 2023 11:08:41 -0500
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 03/15] splice: move permission hook out of
 splice_direct_to_actor()
Message-ID: <ZVObiRlwcKgT0e53@tissot.1015granger.net>
References: <20231114153254.1715969-1-amir73il@gmail.com>
 <20231114153254.1715969-4-amir73il@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114153254.1715969-4-amir73il@gmail.com>
X-ClientProxiedBy: CH0PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:610:76::6) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|PH7PR10MB6312:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7fcf13-5f70-4b5d-f508-08dbe52bf9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7uPOG4TzJ8WFqcBJnq3xZFufpfhIdLUyI0xm6m7Lx0nC0x0Qhhx2KIPTpKCLbDIWTA4LTFdkoK7DPRbKwPGDGNC+2U9GFH4plWj2X5e09bpdJax9T9HMox1njogfUfhCILZWrXRtyZsUK8fuqh0ozChj9pIl5M35wDEe6Qse4IawnTnzOwGvPg14+Au3H4GGb1qzcjkGwAfr4mKaX7zzK7dnqwtbeOuqVpNZvw8p0uSXzVGlbCz8yrXUG/Bg/rk+5GZp+il61UOQgZy8KVvlU2wcD59szwtJCJn2MayCCDfQ++BCA7uY2ahgi4fErnjH5ho6J7c/SI5sLXsz6lIFSCIOFXP2Y5m18huv0/BOa9CtETBHCFBEaf6nJYk4eZ99Iuaz7ojK6rZ4Lg5R6ByiW+5xG+1/KLRJ05KXQKltCxOG1ky7nKbixxb4JeLflrifiUQHfuZrePeBFH3YyyyWR41aESzlvvBcnSBeUF1UTa4iLjWTOADkCsKcMcyhMLtPYN4Zq+boQU0lC/lHVMxis3+tadqZ4Jprcoda2cM9C8ZA6Q1iLuL0PKj2aW4RybP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(86362001)(5660300002)(44832011)(6486002)(66946007)(9686003)(6512007)(316002)(4326008)(66476007)(8936002)(8676002)(66556008)(54906003)(6916009)(41300700001)(2906002)(38100700002)(83380400001)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RfVjuJye/m0a5kFEsO1XqQz5jUsoPBBs2cIYXSTm9s2eHHZwAUN6JZie2VRy?=
 =?us-ascii?Q?5tlskMreOelAOsOFEaG/y6opNWQghWLv3+B/Dy1V/GWYku/S4NOvH5vX5lQG?=
 =?us-ascii?Q?/Bz+7J+/DBBSnJ+wRMP7zZOGmd0dxJA/Ny6i5CuUGit1J51RDvdpRZ56H2pp?=
 =?us-ascii?Q?rklMV97MvVLRpoGuwEHP9Bo1qf7MJI+P00LDvsf5mwRbnHL9jJcx3WdK7eFV?=
 =?us-ascii?Q?1Sw+bgDtlDwc9oiwQgzHUMBUOwHQDdxOIZjF1ML1Cqmgukyf2oShCS2KuZ7M?=
 =?us-ascii?Q?0QfSNVtIB+UXNHVhjlM4E6+TgjiL24Dofie4LEq/hPJTE+C4rFprk5VIISl9?=
 =?us-ascii?Q?CGjgfuKUaHWgx5RUIaSbqU+1qc+1sDArz7hWZDBMGwwLjOd35+znkUWZnLdJ?=
 =?us-ascii?Q?z75KeZDVjMvOeqbEXiRYJHXdPF64g+ed31CwMtJGRlC8nlr69gE64oRYSzt9?=
 =?us-ascii?Q?pgV1p5tOUxRIduDckEPDqBavGxeO7FYu1yprwb0zvGIR3k1CMpdGCNsTeSns?=
 =?us-ascii?Q?ldIApkRFsEKSVR45lgaRf7Yhe84qFSGxr2bSq1U9N/hoB9aTyJblDJFKiaXG?=
 =?us-ascii?Q?R4Ue7t7xocpCq9AOHM4mVNLgDQzx0xVQQHJBKkZl/UC1QJdxfE4Y581k/jpN?=
 =?us-ascii?Q?n0nYY1EJ6u1tPbc4SlIftxylFG42U1D+oO7Ml1gbGzedGGJ+cLW3OkAZVlZB?=
 =?us-ascii?Q?UlGC6RDwp8AhKBXr2Y6NZap+ItRWgfIgd6oWUKWgcU+StPJ86P0VIongJBSk?=
 =?us-ascii?Q?ImIMGjL3ZbHH20N6CX4LFVz8tXCkkghvQH52eeNDLmHBPn6a/9b8assxoFoC?=
 =?us-ascii?Q?4qmFzuJvErhBUKomMp/VJR6jQWrxhAT4yqF2NIq5akT8WcfchB1A71wBOwzL?=
 =?us-ascii?Q?7EQ3swp/HXLuGmVmiXTSKuYmS7AmMVyUbH5eHWD6ThZK/cvpZX8ByUnFwRbH?=
 =?us-ascii?Q?p9Vk9HO9ts2p5CGOxiLJBCq3chBZBQyB4JlEDjmliNRC3DdM/19SB/KKoo4m?=
 =?us-ascii?Q?erM1mctGJUvjgpD8+PJBWg0KXutkhUIY25AJMghJ5xNx1oVu82gtCLg3J/qQ?=
 =?us-ascii?Q?GR+sPAfvpcH4z9/HfhqjxwByQiV8qylMbKyus4jx244YL+WnHaIMCWsRh5/h?=
 =?us-ascii?Q?gqoRmWc5zg9vJ+b1gowGNFLGLZf1IKPeCugqK7H2pmBR6ysqTyxGRljXEOiv?=
 =?us-ascii?Q?eBvo/H3QgcS/XTCczuAB/H11F7sT/vBp89nF5E0ar+2vObew7BlxCESCyLwP?=
 =?us-ascii?Q?3joKO0hCLXICoWdQPOhP2fzxzfljLhTNO9y3b2ijfYE/4agWMwokGIWF4ofc?=
 =?us-ascii?Q?v8R2HP85QFAjZSW7QKWoITUYrUD1Xg3XWRoU/C15nQg6W+gAetBRWhBEBgr5?=
 =?us-ascii?Q?Us4HFbdEGosEJo6NqJPs6xxHNnzevEStUDgOcOZodpSWgDzaq0wKVfv1ecdC?=
 =?us-ascii?Q?TG1b74YTFfmGKOYotmdzOaSwa1Vr+U8CCpz/Gao1sUuPYE9Bq3ZfCLCFHxLo?=
 =?us-ascii?Q?AavZBWgWG2u02arh8aSlfxJBMJ1fMjuyv8sRmgKsGTUF7zjoD4BKADr6AE3S?=
 =?us-ascii?Q?NEqHZymSZk5PC023bf2jesVQP9wOU0fs/XdfiTzUJqPXbbkUY9OVididSRin?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HLSgG3Mmg0rM7EbEWiMKjabB+ibvFXrntEesu9DvBrUZCdcm+mO88Qimrdwi9oNBemFn5dXvSB+UW8MymmJH7ZeOgFSLmswTPSj6nt0OTTK88imER7VUe0uurdKjQTSYkRTu2Jg2hITZb44VEx1/PUbW3d0dr6TZaMDy6r2FgnxhoQcm1hh5tQx/CpNv+8f6JMtyJtvQWkVYMT13EdBnkyzG85jh/+nP5oxG4kEHzXNk7Z3PYwwRen2Q5oymZJ4OmKKqbtO8u38HutVWi+vWDDjb+WLMjlQOrShKVgnghqEpghocg9avshhfP6RKkE2ImtifCqJqw5ZI0hz5eB3g2puAFmMXAo/4NppdW58b8KYvjdLU4yMeL9aQeqYKxm8IeJoGENDkf8Ne9w+gfLqc8zHIGzltrnLjVhaxEIEcQCAMBDCqRojuQZ2FFzPZlxJ+eGdqAYNpU1+CdkH87/r7GHdPnmFkgHL84jdFSjox0ThF2pOG/D6Ki19WijzOoJUEqf/3mv3TCEtFvTj6dziu52kO70qeSBrm9IWCQHPTlCcK731tlkrae5MQyGcKBRs05qunBPv4lh8uFhp8C3SwnIiiODwxrXAmhbt6cVP4TiQKzNu7zDhNKSRQLMSbFda63UTPfD72QzC39so+3xNy2vDxPG/spjOZeMbwlCVXwb3NhGyQ9QbQbFczu7G4aFblvD1ndoY83hvqb2jehimFTkZ6hjKT20PydF15sVeSkvcHiQA1Rj1Lgx0tbevoTTfnWhe8muM1Z99tG9blAeemsC0vXyoW7tdcbVDTBTBb2RZMctmuB8YZkfH8mCd1tNMaic02co1rd57xrzlrCnAMcRbjM1VkBH7RqKwWH0bXHOs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7fcf13-5f70-4b5d-f508-08dbe52bf9de
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 16:08:44.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nj3Xj+dy1zLA9MwgEBuNemjQQdzQk2PLL3r88vK50boA11MDonXcJWJ2Q2y2aC37zgph9bqwtxfy9Fy2MjFbYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_16,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140123
X-Proofpoint-ORIG-GUID: le5o0kQ0ixMHJOkP2-u9TqFJTbXiwG30
X-Proofpoint-GUID: le5o0kQ0ixMHJOkP2-u9TqFJTbXiwG30
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 14, 2023 at 05:32:42PM +0200, Amir Goldstein wrote:
> vfs_splice_read() has a permission hook inside rw_verify_area() and
> it is called from do_splice_direct() -> splice_direct_to_actor().
> 
> The callers of do_splice_direct() (e.g. vfs_copy_file_range()) already
> call rw_verify_area() for the entire range, but the other caller of
> splice_direct_to_actor() (nfsd) does not.
> 
> Add the rw_verify_area() checks in nfsd_splice_read() and use a
> variant of vfs_splice_read() without rw_verify_area() check in
> splice_direct_to_actor() to avoid the redundant rw_verify_area() checks.
> 
> This is needed for fanotify "pre content" events.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Chuck Lever <chuck.lever@oracle.com>

> ---
>  fs/nfsd/vfs.c |  5 ++++-
>  fs/splice.c   | 58 +++++++++++++++++++++++++++++++--------------------
>  2 files changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index fbbea7498f02..5d704461e3b4 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1046,7 +1046,10 @@ __be32 nfsd_splice_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  	ssize_t host_err;
>  
>  	trace_nfsd_read_splice(rqstp, fhp, offset, *count);
> -	host_err = splice_direct_to_actor(file, &sd, nfsd_direct_splice_actor);
> +	host_err = rw_verify_area(READ, file, &offset, *count);
> +	if (!host_err)
> +		host_err = splice_direct_to_actor(file, &sd,
> +						  nfsd_direct_splice_actor);
>  	return nfsd_finish_read(rqstp, fhp, file, offset, count, eof, host_err);
>  }
>  
> diff --git a/fs/splice.c b/fs/splice.c
> index 6e917db6f49a..6fc2c27e9520 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -944,27 +944,15 @@ static void do_splice_eof(struct splice_desc *sd)
>  		sd->splice_eof(sd);
>  }
>  
> -/**
> - * vfs_splice_read - Read data from a file and splice it into a pipe
> - * @in:		File to splice from
> - * @ppos:	Input file offset
> - * @pipe:	Pipe to splice to
> - * @len:	Number of bytes to splice
> - * @flags:	Splice modifier flags (SPLICE_F_*)
> - *
> - * Splice the requested amount of data from the input file to the pipe.  This
> - * is synchronous as the caller must hold the pipe lock across the entire
> - * operation.
> - *
> - * If successful, it returns the amount of data spliced, 0 if it hit the EOF or
> - * a hole and a negative error code otherwise.
> +/*
> + * Callers already called rw_verify_area() on the entire range.
> + * No need to call it for sub ranges.
>   */
> -long vfs_splice_read(struct file *in, loff_t *ppos,
> -		     struct pipe_inode_info *pipe, size_t len,
> -		     unsigned int flags)
> +static long do_splice_read(struct file *in, loff_t *ppos,
> +			   struct pipe_inode_info *pipe, size_t len,
> +			   unsigned int flags)
>  {
>  	unsigned int p_space;
> -	int ret;
>  
>  	if (unlikely(!(in->f_mode & FMODE_READ)))
>  		return -EBADF;
> @@ -975,10 +963,6 @@ long vfs_splice_read(struct file *in, loff_t *ppos,
>  	p_space = pipe->max_usage - pipe_occupancy(pipe->head, pipe->tail);
>  	len = min_t(size_t, len, p_space << PAGE_SHIFT);
>  
> -	ret = rw_verify_area(READ, in, ppos, len);
> -	if (unlikely(ret < 0))
> -		return ret;
> -
>  	if (unlikely(len > MAX_RW_COUNT))
>  		len = MAX_RW_COUNT;
>  
> @@ -992,6 +976,34 @@ long vfs_splice_read(struct file *in, loff_t *ppos,
>  		return copy_splice_read(in, ppos, pipe, len, flags);
>  	return in->f_op->splice_read(in, ppos, pipe, len, flags);
>  }
> +
> +/**
> + * vfs_splice_read - Read data from a file and splice it into a pipe
> + * @in:		File to splice from
> + * @ppos:	Input file offset
> + * @pipe:	Pipe to splice to
> + * @len:	Number of bytes to splice
> + * @flags:	Splice modifier flags (SPLICE_F_*)
> + *
> + * Splice the requested amount of data from the input file to the pipe.  This
> + * is synchronous as the caller must hold the pipe lock across the entire
> + * operation.
> + *
> + * If successful, it returns the amount of data spliced, 0 if it hit the EOF or
> + * a hole and a negative error code otherwise.
> + */
> +long vfs_splice_read(struct file *in, loff_t *ppos,
> +		     struct pipe_inode_info *pipe, size_t len,
> +		     unsigned int flags)
> +{
> +	int ret;
> +
> +	ret = rw_verify_area(READ, in, ppos, len);
> +	if (unlikely(ret < 0))
> +		return ret;
> +
> +	return do_splice_read(in, ppos, pipe, len, flags);
> +}
>  EXPORT_SYMBOL_GPL(vfs_splice_read);
>  
>  /**
> @@ -1066,7 +1078,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  		size_t read_len;
>  		loff_t pos = sd->pos, prev_pos = pos;
>  
> -		ret = vfs_splice_read(in, &pos, pipe, len, flags);
> +		ret = do_splice_read(in, &pos, pipe, len, flags);
>  		if (unlikely(ret <= 0))
>  			goto read_failure;
>  
> -- 
> 2.34.1
> 

-- 
Chuck Lever
