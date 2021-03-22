Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62569C433E9
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4881D61990
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhCVMhn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:37:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhCVMfs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MCQAtV193184;
        Mon, 22 Mar 2021 12:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TlvoWOwV3yypfKOV8uJvzW1RiiII8kAPWZEHDE3jc3w=;
 b=L2rAdTPFQEME/S/d7qb0wCOi9ZEWZapET3P4rX5akCvixdlEMvpM0fHPl8g68zMcUdmI
 50jfxrZBtGqc803/CKWU23n82EAhbWBhEwbwA6pk6bHk1aPKkFM8dN2e/8VsVu7S5GcM
 BShDC+JcWWIxrVrckdUcYaZ3VPIZvd5dmyKVL+7oPLTyAXzuHmhnzLjm6l4c1xLxFtN5
 jPh0ZDn5g05FYtbeZQZbJI97rVJ1aJzbkqlzsWB8qz6zl7cAUq2AUvu5Aic5NXI2xwDr
 M+s8Lyw5tqg2OvZwbs7PCSwJBGyIlZp/DW7qSq4Uh88JEpT8YXfrYHjGrQjKz6YkyDfj 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37d90mbaw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 12:35:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MCQI2S072628;
        Mon, 22 Mar 2021 12:35:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 37dtxwwc7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 12:35:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12MCZgkD001234;
        Mon, 22 Mar 2021 12:35:42 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Mar 2021 05:35:41 -0700
Date:   Mon, 22 Mar 2021 15:35:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [bug report] ovl: copy up of disconnected dentries
Message-ID: <20210322123534.GG1667@kadam>
References: <YFiK/GhGReGqh52w@mwanda>
 <CAOQ4uxjNVHGReF5_TXBXHdVb0asJ4RQH_CT6Gy7r1J8MWEe1yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjNVHGReF5_TXBXHdVb0asJ4RQH_CT6Gy7r1J8MWEe1yg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220091
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 22, 2021 at 02:25:44PM +0200, Amir Goldstein wrote:
> On Mon, Mar 22, 2021 at 2:18 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > Hello Amir Goldstein,
> >
> > The patch aa3ff3c152ff: "ovl: copy up of disconnected dentries" from
> > Oct 15, 2017, leads to the following static checker warning:
> 
> Heh! that's fashionably late :)
> 

;)

> >
> >         fs/overlayfs/copy_up.c:972 ovl_copy_up_flags()
> >         warn: 'old_cred' not released on lines: 944.
> >
> > fs/overlayfs/copy_up.c
> >    932  static int ovl_copy_up_flags(struct dentry *dentry, int flags)
> >    933  {
> >    934          int err = 0;
> >    935          const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
> >    936          bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
> >    937
> >    938          /*
> >    939           * With NFS export, copy up can get called for a disconnected non-dir.
> >    940           * In this case, we will copy up lower inode to index dir without
> >    941           * linking it to upper dir.
> >    942           */
> >    943          if (WARN_ON(disconnected && d_is_dir(dentry)))
> >    944                  return -EIO;
> >
> > Should this call revert_creds(old_cred); before returning?
> 
> Yes. Here's a simple fix, care to post it?

Sure.  I'm always happy to take credit for your work.  I'll send it
tomorrow.

regards,
dan carpenter

