From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 22 Sep 2017 08:10:48 +0530
Message-ID: <2797154.7lILCH11n2@localhost.localdomain>
References: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com> <2098530.dS0XS0MFtf@localhost.localdomain> <CAOQ4uxi1TrUtFZAdn-j65Y9gNeg9Vi0+0LRk9_Ve_C=9rkbVsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751780AbdIVCkI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2017 22:40:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8M2dlSV039622
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2017 22:40:08 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d4png22ag-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2017 22:40:07 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 22 Sep 2017 12:40:05 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v8M2e2Js37814290
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Sep 2017 12:40:02 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v8M2e4O5004812
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Sep 2017 12:40:04 +1000
In-Reply-To: <CAOQ4uxi1TrUtFZAdn-j65Y9gNeg9Vi0+0LRk9_Ve_C=9rkbVsQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thursday, September 21, 2017 11:16:26 PM IST Amir Goldstein wrote:
> On Thu, Jul 27, 2017 at 9:24 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > On Monday, July 24, 2017 2:47:22 PM IST Chandan Rajendra wrote:
> >> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> >> provides unique values for st_dev. The unique values are obtained by
> >> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> >> instance.
> >>
> >> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> >> ---
> >> Changelog:
> >>
> >> v2->v3: Optimize away O(n) search for pseudo dev in ovl_get_pseudo_dev().
> >>
> >> v1->v2: Drop code that provided unique st_dev across copy up.
> >>
> >
> > I have rebased Amir's "ovl: relax same fs constrain for constant st_ino"
> > patch on top of the changes made in this patch. The tree containing
> > the rebased patch can be found at
> > "https://github.com/chandanr/linux.git rework-anonymous-dev"
> >
> > I have tested this by executing unionmount-testsuite's "./run --ov --verify".
> >
> 
> 
> Chandan,
> 
> Can you rebase your work on v4.14-rc1?
> 
> You now need to add another patch to relax same fs constrain for
> constant d_ino in readdir.
> Note that you will also need to relax in ovl_cache_update_ino()
> WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev)
> 
> unionmount-testsuite's --verify (non-samefs) does not verify d_ino and
> the your constant d_ino xfstest does not cover the non-samefs case.
> A new xfstest, a simple variant of your samefs xfstest should be sufficient.
> 

Sure, I will do that and post the patches soon.

-- 
chandan
