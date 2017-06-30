From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Fri, 30 Jun 2017 21:53:12 +0530
Message-ID: <3572960.FHoPbXkqrf@localhost.localdomain>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com> <CAOQ4uxgtBzq8_HtSfKxGNT3mx_erg3MHw09z-ZQ25GK3RJFk6w@mail.gmail.com> <CAJfpeguKE2o=6bQm6q99oZXoP5w8Qt0qKZzbRDm7kGS0wYzvmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56775 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750975AbdF3QWx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Jun 2017 12:22:53 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5UGKkh1146315
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 12:22:53 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bdmqt5ve7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 12:22:52 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 1 Jul 2017 02:22:50 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5UGMmGi5898558
        for <linux-unionfs@vger.kernel.org>; Sat, 1 Jul 2017 02:22:48 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5UGMlq3001977
        for <linux-unionfs@vger.kernel.org>; Sat, 1 Jul 2017 02:22:48 +1000
In-Reply-To: <CAJfpeguKE2o=6bQm6q99oZXoP5w8Qt0qKZzbRDm7kGS0wYzvmA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wednesday, June 21, 2017 3:18:20 PM IST Miklos Szeredi wrote:
> On Wed, Jun 21, 2017 at 11:36 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Jun 21, 2017 at 12:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Wed, Jun 21, 2017 at 11:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> >>>
> >>> Following up on your idea:
> >>> - check in ovl_iterate() if version has changed and if dir became impure
> >>> - if it did, populate od->cache, but keep the dir od->is_real
> >>> - iterate upper cache entries and call ovl_cache_update_ino()
> >>> - Then actor of real dir iterator can use the cache to ommit entries or use
> >>>   p->ino from cache if p->real_ino match real d_ino, but differs from p->ino.
> >>
> >> For non-merge dirs we can have a simplified cache just containing the
> >> entries with origin, recreated when the version changes or updated in
> >> rename, whichever is simpler.  A non-merge dir will never become a
> >> merge one, so we can keep the handling separate.
> >>
> >
> > And use this cache to ommit/fix entries with actor?
> 
> Right.  I think fixing up is better, because to correctly omit entries
> we'd need separate lists for each open directory.  For fixing up we
> can use a common one, just like for the merged dir.
> 

Amir, Can I please take over the implementation of this feature.

-- 
chandan
