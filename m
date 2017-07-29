From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Sat, 29 Jul 2017 16:56:13 +0530
Message-ID: <1727524.G1ItpzJC8o@localhost.localdomain>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com> <CAJfpeguM5eS2caT_k6wE++sSrBi9kGE1aLys5h6a5S+tQGJg6A@mail.gmail.com> <CAOQ4uxif79cbhYJxgHzkG0jpNgginMimvfgm-iSXAnuRkmWUqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40015 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753179AbdG2L0l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Jul 2017 07:26:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6TBOLVZ140385
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Jul 2017 07:26:40 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c0pgtngv9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Jul 2017 07:26:40 -0400
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 29 Jul 2017 21:26:37 +1000
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6TBQQoR18874422
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Jul 2017 21:26:34 +1000
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v6TBQ1vg003383
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Jul 2017 21:26:02 +1000
In-Reply-To: <CAOQ4uxif79cbhYJxgHzkG0jpNgginMimvfgm-iSXAnuRkmWUqw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Friday, July 28, 2017 2:55:56 PM IST Amir Goldstein wrote:
> On Thu, Jul 27, 2017 at 11:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, Jun 21, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Wed, Jun 21, 2017 at 11:36 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> On Wed, Jun 21, 2017 at 12:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>>> On Wed, Jun 21, 2017 at 11:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>>
> >>>>>
> >>>>> Following up on your idea:
> >>>>> - check in ovl_iterate() if version has changed and if dir became impure
> >>>>> - if it did, populate od->cache, but keep the dir od->is_real
> >>>>> - iterate upper cache entries and call ovl_cache_update_ino()
> >>>>> - Then actor of real dir iterator can use the cache to ommit entries or use
> >>>>>   p->ino from cache if p->real_ino match real d_ino, but differs from p->ino.
> >>>>
> >>>> For non-merge dirs we can have a simplified cache just containing the
> >>>> entries with origin, recreated when the version changes or updated in
> >>>> rename, whichever is simpler.  A non-merge dir will never become a
> >>>> merge one, so we can keep the handling separate.
> >>>>
> >>>
> >>> And use this cache to ommit/fix entries with actor?
> >>
> >> Right.  I think fixing up is better, because to correctly omit entries
> >> we'd need separate lists for each open directory.  For fixing up we
> >> can use a common one, just like for the merged dir.
> >
> > And back to this, I pushed a branch named "ovl-d_ino" to my vfs tree.
> >
> > Please test.
> >
> 
> I can confirm that xfstest  overlay/017, the only  test I have for
> constant d_ino,
> passes. Although it does not cover all cases handled by the patch set
> (e.g. d_ino of merge parent).
> 
> Chandan,
> 
> Can you take on the task of improving test coverage for constant d_ino?
> You should create a new xfstest and cover more cases of constant d_ino
> and possibly also a test for clearing of impure xattr.
> 
> When the basic test is in place, I will be able to point at more corner cases
> to cover.
> 
> Also need to prepare a test to verify constant d_ino for non samefs
> for after this patch is integrated with your work.
> overlay/017 is a good starting point, but can't use the standard _scratch_mount
> helpers that mount samefs overlay.

I will work on that.

-- 
chandan
