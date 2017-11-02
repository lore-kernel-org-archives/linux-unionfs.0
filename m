From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Thu, 2 Nov 2017 10:05:03 -0400
Message-ID: <20171102140503.GA14907@redhat.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com>
 <20171101144249.GA8259@redhat.com>
 <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
 <20171101154700.GA3125@redhat.com>
 <CAOQ4uxhpq_mEyyUj0M5AELPYGuHwyCpxz9+HE4K0qaY1+-XQGw@mail.gmail.com>
 <20171102122730.GA16677@redhat.com>
 <CAOQ4uxiQSuQo0jrRZwiq_66zgcfb_pYdBJHqC_vrkF0oyQCy3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755691AbdKBOFG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 10:05:06 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiQSuQo0jrRZwiq_66zgcfb_pYdBJHqC_vrkF0oyQCy3A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Nov 02, 2017 at 02:47:07PM +0200, Amir Goldstein wrote:
> On Thu, Nov 2, 2017 at 2:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Nov 01, 2017 at 06:41:51PM +0200, Amir Goldstein wrote:
> >
> > [..]
> >> >> I can't remember if there was a reason for not allocating anonymous bdev
> >> >> for upper
> >> >
> >> > That's a good point.
> >> >
> >> >> or if it just because we did not need it to guaranty uniqueness
> >> >> of st_dev/st_ino *among* overlay inodes
> >> >
> >> > Even for lower, st_dev will be unique for different lower on non same-fs,
> >> > right. IOW, when it come to uniqueness of st_dev/st_ino pair, among
> >> > overlay inodes, lower and upper should have same requirements.
> >> >
> >> >> while guarantying constant
> >> >> st_dev/st_ino across copy up.
> >> >
> >> > Hmm..., I did not get this point. Over copy up, atleast st_ino will change
> >> > for non-samefs case.
> >> >
> >> > I will spend more time on patch.
> >> >
> >>
> >> Urgh! It took me a while to remember the reason why system wide uniqueness
> >> is important for lower but less for upper.
> >> An upper object has the same content as the "real" object and they have the
> >> same st_ino/st_dev so its ok that diff will skip comparing them.
> >> A copy-up object does not have the same content as the lower "real" object,
> >> so if it has the same st_ino/st_dev as real object, diff will skip compare and
> >> we have a problem.
> >
> > I am not sure I understand this.  So you are doing a diff between a file
> > on overlayfs and same file accessed outside overlayfs?
> >
> 
> Yes.
> 
> > If a file is on lower, then it has not been modified and diff skipping
> > it makes perfect sense?
> 
> Yes.
> 
> But!
> With constant st_ino/st_dev across copy up (the next patch)
> the overlay object still has the lower inode st_dev/st_inode also *after*
> copy up and modification. Now if you diff overlay file and lower
> file diff will say they are equal, but in fact they have a different content.
> 
> This is how I phrased this in latest patch set per your request:

Ok, I think I am beginning to understand it. Here is my understanding.
Please correct me if something is not right.

So we basically have 4 core requirements.

A. contstant st_dev/st_ino over copy up.
B. Persistent st_ino
C. unique st_dev/st_ino
D. Diff works fine even after copy up.

As of today, for non-samefs case, ovl_getattr() reports st_dev/st_ino of
*real* file. This meets requirement B and C and D but not requirement A. 

To meet requirement A, one could make use of ORIGIN xattr and report
st_dev/st_ino of lower (even after file got copied up). This will
meet requirement A, B and C but not D. 

So to make all 4 work for non-samefs case, we don't report real st_dev
of lower and instead create a pseudo dev and report that. IOW, for
non-same fs case, report pseudo_st_dev/real_st_ino of lower. And
that should meet all the 4 core requirements.

And this patch series implements this.

If this description is correct, I feel some of this should be used
in changelog somewhere to make it easier to understand the rationale
behind the change.


Thanks
Vivek



> 
> -----------------------
> [V6 4/9] ovl: return anonymous st_dev for lower inodes
> 
> For non-samefs setup, to make sure that st_dev/st_ino pair
> is unique across the system, we return a unique anonymous
> st_dev for stat(2) of lower layer inode.
> 
> We need to make this change before fixing constant st_dev/st_ino across
> copy up for non-samefs. Otherwise, we can end up with two objects
> in the system, the real lower inode and the overlay inode which
> have same st_dev/st_ino value, but different content.
> 
> 
> Hope this is clear.
> 
> Amir.
