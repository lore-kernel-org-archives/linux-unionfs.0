From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 23 Jun 2017 19:12:01 +0530
Message-ID: <1524540.8yrY45Xexk@localhost.localdomain>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com> <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752756AbdFWQrv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:47:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5NGi0f7036626
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 12:47:50 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b96n6gakf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 12:47:50 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 24 Jun 2017 02:47:47 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5NGliT957933992
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Jun 2017 02:47:44 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5NGlg8l020602
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Jun 2017 02:47:42 +1000
In-Reply-To: <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Friday, June 23, 2017 7:04:57 PM IST Amir Goldstein wrote:
> On Fri, Jun 23, 2017 at 2:01 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> > provides unique values for st_dev. The unique values are obtained by
> > allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> > instance.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Tested-by: Amir Goldstein <amir73il@gmail.com>
> 
> Miklos,
> 
> I re-created the branch ovl-constino [1] on top of ovl-hardlinks and without
> the consistent dino patches.
> 
> Applied Chandan's patch and resolved conflicts with my patches.
> Then, applied my patch to relax constant st_ino  for non-samefs on stat(2).
> 
> Mutilated unionmount-testsuite layers check [2] to get over the unexpected
> pseudo dev and now tests pass for non samefs including constant ino
> verification and persistent ino verification for non-dir.
> 
> Chandan,
> 
> If you can fix the mutilated unionmount-testsuite check_layer(), that would be
> nice.
> 

Sure, I will work on it right away. Thanks for your guidance.


-- 
chandan
