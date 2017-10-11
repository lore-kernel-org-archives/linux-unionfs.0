From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 7/9] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Thu, 12 Oct 2017 00:08:04 +0300
Message-ID: <CAOQ4uxgKtG=6QdqPbrkHJTGFS_h2_9SmNeWphwso3uFtM4N4dg@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-8-git-send-email-vgoyal@redhat.com> <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
 <20171011202713.GF8086@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38653 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbdJKVIG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 17:08:06 -0400
Received: by mail-qt0-f194.google.com with SMTP id k31so4047611qta.5
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2017 14:08:05 -0700 (PDT)
In-Reply-To: <20171011202713.GF8086@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, Oct 11, 2017 at 11:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Oct 10, 2017 at 08:12:00PM +0300, Amir Goldstein wrote:
>> On Tue, Oct 10, 2017 at 6:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > We can access and check metacopy flag outside ovl_inode->lock. IOW, say
>> > a file was meta copied up in the past and it has metacopy flag set. Now
>> > a data copy up operation in progress. Say another thread reads state of
>> > this flag and if flag clearing is visible before file has been fully
>> > copied up, that can cause problems.
>> >
>> >         CPU1                            CPU2
>> > ovl_copy_up_flags()                     acquire(oi->lock)
>> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data_inode()
>> >    ovl_test_metacopy_flag()                 ovl_copy_up_data()
>> >                                             ovl_clear_metacopy_flag()
>> >                                         release(oi->lock)
>> >
>> > Say CPU2 is copying up data and in the end clears metacopy flag. But if
>> > CPU1 perceives clearing of metacopy before actual data copy up operation
>> > being finished, that can become a problem. We want this clearing of flag
>> > to be visible only if all previous write operations have finished.
>> >
>> > Hence this patch introduces smp_wmb() on metacopy flag set/clear operation
>> > and smp_rmb() on metacopy flag test operation.
>> >
>> > May be some other lock or barrier is already covering it. But I am not sure
>> > what that is and is it obvious enough that we will not break it in future.
>> >
>> > So hence trying to be safe here and introducing barriers explicitly for
>> > metacopy bit.
>>
>> Please revisit your changes after addressing my comment on patch 5.
>
> Assume, we added smp_rmb() in ovl_upperdentry_dereference(), to make
> sure by the time upperdentry is visible, OVL_METACOPY is visible too.
>
>> IIUC the flow you describe above should be addressed by testing
>> metacopy flag again under ovl inode lock.
>>
>> The only subtle part imo is making metacopy flag visible
>> Before making upper dentry visible.
>> Clearing metacopy flag should not be a problem imo,
>> As it comes after fsync, but didn't look closely.
>
> Say a file has been metadata copied up only. So upper is visible and
> OVL_METACOPY flag is set.
>
> Now, what happens if two paths try to data copy up the file. Say first
> path gets the oi->lock and starts doing data copy. Second path enters
> ovl_copy_up_flags() and checks if data copy up is required or not. If
> OVL_METACOPY is still set, then second process will block on oi->lock
> and once first process exits will check OVL_METACOPY again under lock
> and bail out. So that is not a problem.
>
> What about the other case. That is OVL_METACOPY gets cleared before
> data copy operation is complete. If I don't introduce smp_wmb()/smp_rmb()
> around resetting of OVL_METACOPY, what will make sure that
> ovl_copy_up_flags() will see OVL_METACOPY=0 only after data copy up is
> complete. Of course we will not like to return to caller of
> ovl_copy_up_flags() while data copy up is still going on on a different
> cpu.
>

vfs_removexattr() between data copy up and clearing OVL_METACOPY
takes inode lock.
IIUC, any lock/unlock has a full memory barrier.

Amir.
