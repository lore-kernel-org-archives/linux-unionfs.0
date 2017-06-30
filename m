From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 30 Jun 2017 16:28:29 +0530
Message-ID: <2041782.HUJ34Am32x@localhost.localdomain>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com> <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com> <2369642.ypcN4zZqWi@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33009 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752347AbdF3K6K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Jun 2017 06:58:10 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5UAmbDD063227
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 06:58:10 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bdkpym2mr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 06:58:09 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 30 Jun 2017 20:58:07 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5UAw5Uw2359580
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 20:58:05 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5UAvuJm013567
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 20:57:57 +1000
In-Reply-To: <2369642.ypcN4zZqWi@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tuesday, June 27, 2017 1:01:17 PM IST Chandan Rajendra wrote:
> On Friday, June 23, 2017 7:04:57 PM IST Amir Goldstein wrote:
> > On Fri, Jun 23, 2017 at 2:01 PM, Chandan Rajendra
> > <chandan@linux.vnet.ibm.com> wrote:
> > > For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> > > provides unique values for st_dev. The unique values are obtained by
> > > allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> > > instance.
> > >
> > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > > ---
> > 
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Tested-by: Amir Goldstein <amir73il@gmail.com>
> > 
> > Miklos,
> > 
> > I re-created the branch ovl-constino [1] on top of ovl-hardlinks and without
> > the consistent dino patches.
> > 
> > Applied Chandan's patch and resolved conflicts with my patches.
> > Then, applied my patch to relax constant st_ino  for non-samefs on stat(2).
> > 
> > Mutilated unionmount-testsuite layers check [2] to get over the unexpected
> > pseudo dev and now tests pass for non samefs including constant ino
> > verification and persistent ino verification for non-dir.
> > 
> > Chandan,
> > 
> > If you can fix the mutilated unionmount-testsuite check_layer(), that would be
> > nice.
> > 
> 

Hi Amir,

In dentry.created(), we have

        self.__upper = on_upper or not inode or inode.filetype() == "d"

Do you happen to know why we mark the dentry as being present on the upperdir
filesystem when "inode" evaluates to false?

Consider the case of /lowerdir/a/foo101 file being created in
set_up.py. ctx.record_file() ends up creating a new 'dentry' object with no
inode associated with it. Hence self.__upper is set to the value True. Isn't
this incorrect since the file foo101 is actually being created on lowerdir?

I added the following new test scenario to check_layer() code,

   elif dentry.on_upper() and not self.config().is_samefs() and dev != self.upper_fs():
          raise TestError(name + ": Upperdir file has incorrect dev id")

In the above code snippet, dentry.on_upper() incorrectly evaluates to True and
hence we end up raising an exception.

Maybe dentry.created should have the following statement instead,

     self.__upper = on_upper or (inode and inode.filetype() == "d")

-- 
chandan
