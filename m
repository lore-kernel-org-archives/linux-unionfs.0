From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/13] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Fri, 27 Oct 2017 07:35:00 +0300
Message-ID: <CAOQ4uxhGrA2XW3D9GmCdz4KdwfnbgbG-K9YvA10GDdDwN9=pYw@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-12-git-send-email-vgoyal@redhat.com> <CAOQ4uxio4ZESiJ35dAimnFW_YcdEpmRCPqMPDB5i2AWvRg2WOA@mail.gmail.com>
 <20171026175458.GB6704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:57071 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdJ0EfB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Oct 2017 00:35:01 -0400
Received: by mail-yw0-f196.google.com with SMTP id l32so4745139ywh.13
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2017 21:35:01 -0700 (PDT)
In-Reply-To: <20171026175458.GB6704@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 8:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 26, 2017 at 09:34:15AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If a file is copied up metadata only and later when same file is opened
>> > for WRITE, then data copy up takes place. We copy up data, remove METACOPY
>> > xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
>> > these operations happen with oi->lock held, read side of oi->flags is
>> > lockless. That is another thread on another cpu can check if UPPERDATA
>> > flag is set or not.
>> >
>> > So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
>> > another cpu sees UPPERDATA flag set, then it should be guaranteed that
>> > effects of data copy up and remove xattr operations are also visible.
>> >
>> > For example.
>> >
>> >         CPU1                            CPU2
>> > ovl_copy_up_flags()                     acquire(oi->lock)
>> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data()
>> >    ovl_test_flag(OVL_UPPERDATA)           vfs_removexattr()
>> >                                           ovl_set_flag(OVL_UPPERDATA)
>> >                                         release(oi->lock)
>> >
>> > Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
>> > CPU1 perceives the effects of setting UPPERDATA flag but not effects of
>> > preceeding operations, that would be a problem.
>>
>> Why would that be a problem?
>> What can go wrong?
>
> That's a good question. I really don't have a concrete example where I can
> say this this can go wrong. Can you think of something.
>
>> If you try to answer the question instead of referring to a vague "problem"
>> you will see that only the ovl_d_real() code path can be a problem.
>
> Right. And ovl_copy_up_flags() will be called from ovl_d_real().  Will
> update it to show cover more of parent chain.
>

That is not what I meant.
I don't see any negative outcome that could happen from false view
of OVL_UPPERDATA flag in ovl_copy_up_flags().
The race with ovl_instantiate() you pointed out is interesting, but easy to
solve by checking for non-NULL lower.

The path of ovl_d_real() that exposes upper inode to early is the only
path I see that can cause problems, as well as perhaps ovl_getattr(),
which may expose wrong blocks.

Amir.
