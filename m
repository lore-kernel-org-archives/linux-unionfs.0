From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Tue, 27 Jun 2017 13:01:17 +0530
Message-ID: <2369642.ypcN4zZqWi@localhost.localdomain>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com> <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37241 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752230AbdF0HbA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Jun 2017 03:31:00 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5R7SaO7044016
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jun 2017 03:30:59 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bb2b3xqph-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jun 2017 03:30:59 -0400
Received: from localhost
        by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 27 Jun 2017 17:30:56 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5R7UrQ95439800
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jun 2017 17:30:53 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5R7Uj9j000992
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jun 2017 17:30:45 +1000
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

Amir,

In check_layer() we have the following,

            # TODO: for non-samefs, check file dev matches pseudo dev
            # and that pseduo dev != real dev
            raise TestError(name + ": File on unexpected layer")

"check file dev matches pseudo dev" ... To do this we would have to
have the list of pseudo dev ids for each of the lowerdirs.  One crude
way of getting such a list would be to create files having names with
a known prefix under each of the lowerdirs before mounting the
overlayfs instance.  After mounting the overlayfs instance we could do
a stat(2) on $overlay_mount/tempfile[i] to get the pseudo dev ids.

These pseudo dev ids can then be used in check_layer().

Please let me know your views on this.

-- 
chandan
