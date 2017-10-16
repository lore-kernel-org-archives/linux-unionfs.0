From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 7/9] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Mon, 16 Oct 2017 09:24:02 -0400
Message-ID: <20171016132402.GA31318@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-8-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
 <20171011202713.GF8086@redhat.com>
 <CAOQ4uxgKtG=6QdqPbrkHJTGFS_h2_9SmNeWphwso3uFtM4N4dg@mail.gmail.com>
 <20171013182706.GA23232@redhat.com>
 <CAOQ4uxj1eUq8OWaG4-Fw4Kx2v6jB4p5bwaU6S-iJU7j9vTwEhQ@mail.gmail.com>
 <CAOQ4uxgSJKcUAESQu7zuqT_AFM0m7Pq1EEh0eQyhe0cMHo5dCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752056AbdJPNYE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:24:04 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgSJKcUAESQu7zuqT_AFM0m7Pq1EEh0eQyhe0cMHo5dCQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Sat, Oct 14, 2017 at 10:00:44AM +0300, Amir Goldstein wrote:
> On Sat, Oct 14, 2017 at 9:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Fri, Oct 13, 2017 at 9:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Thu, Oct 12, 2017 at 12:08:04AM +0300, Amir Goldstein wrote:
> >>> On Wed, Oct 11, 2017 at 11:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>> > On Tue, Oct 10, 2017 at 08:12:00PM +0300, Amir Goldstein wrote:
> >>> >> On Tue, Oct 10, 2017 at 6:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>> >> > We can access and check metacopy flag outside ovl_inode->lock. IOW, say
> >>> >> > a file was meta copied up in the past and it has metacopy flag set. Now
> >>> >> > a data copy up operation in progress. Say another thread reads state of
> >>> >> > this flag and if flag clearing is visible before file has been fully
> >>> >> > copied up, that can cause problems.
> >>> >> >
> >>> >> >         CPU1                            CPU2
> >>> >> > ovl_copy_up_flags()                     acquire(oi->lock)
> >>> >> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data_inode()
> >>> >> >    ovl_test_metacopy_flag()                 ovl_copy_up_data()
> >>> >> >                                             ovl_clear_metacopy_flag()
> >>> >> >                                         release(oi->lock)
> >>> >> >
> >>> >> > Say CPU2 is copying up data and in the end clears metacopy flag. But if
> >>> >> > CPU1 perceives clearing of metacopy before actual data copy up operation
> >>> >> > being finished, that can become a problem. We want this clearing of flag
> >>> >> > to be visible only if all previous write operations have finished.
> >>> >> >
> >>> >> > Hence this patch introduces smp_wmb() on metacopy flag set/clear operation
> >>> >> > and smp_rmb() on metacopy flag test operation.
> >>> >> >
> >>> >> > May be some other lock or barrier is already covering it. But I am not sure
> >>> >> > what that is and is it obvious enough that we will not break it in future.
> >>> >> >
> >>> >> > So hence trying to be safe here and introducing barriers explicitly for
> >>> >> > metacopy bit.
> >>> >>
> >>> >> Please revisit your changes after addressing my comment on patch 5.
> >>> >
> >>> > Assume, we added smp_rmb() in ovl_upperdentry_dereference(), to make
> >>> > sure by the time upperdentry is visible, OVL_METACOPY is visible too.
> >>> >
> >>> >> IIUC the flow you describe above should be addressed by testing
> >>> >> metacopy flag again under ovl inode lock.
> >>> >>
> >>> >> The only subtle part imo is making metacopy flag visible
> >>> >> Before making upper dentry visible.
> >>> >> Clearing metacopy flag should not be a problem imo,
> >>> >> As it comes after fsync, but didn't look closely.
> >>> >
> >>> > Say a file has been metadata copied up only. So upper is visible and
> >>> > OVL_METACOPY flag is set.
> >>> >
> >>> > Now, what happens if two paths try to data copy up the file. Say first
> >>> > path gets the oi->lock and starts doing data copy. Second path enters
> >>> > ovl_copy_up_flags() and checks if data copy up is required or not. If
> >>> > OVL_METACOPY is still set, then second process will block on oi->lock
> >>> > and once first process exits will check OVL_METACOPY again under lock
> >>> > and bail out. So that is not a problem.
> >>> >
> >>> > What about the other case. That is OVL_METACOPY gets cleared before
> >>> > data copy operation is complete. If I don't introduce smp_wmb()/smp_rmb()
> >>> > around resetting of OVL_METACOPY, what will make sure that
> >>> > ovl_copy_up_flags() will see OVL_METACOPY=0 only after data copy up is
> >>> > complete. Of course we will not like to return to caller of
> >>> > ovl_copy_up_flags() while data copy up is still going on on a different
> >>> > cpu.
> >>> >
> >>>
> >>> vfs_removexattr() between data copy up and clearing OVL_METACOPY
> >>> takes inode lock.
> >>> IIUC, any lock/unlock has a full memory barrier.
> >>
> >> When I read memory-barrier.txt, it seems to suggest that RELEASE can let
> >> instructions outside critical region sneak into critical region. If that's
> >> the case, actually clearing of metaflag can happen before xattr actually
> >> got removed. Though I can't think what will go wrong in that case.
> >
> > clear_bit takes a spinlock so I *think* clearing of flag cannot sneak
> > before removing xattr.
> >
> >>
> >> Also will all this work without other cpu having any matching barrier?
> >> Again, I am not barrier expert and I am trying to understand these and
> >
> > Me neither, trying to understand this along with you.
> >
> >> one of the messages seems to be that most of the time they have to be
> >> paired. So in this case, we are taking inode lock/unlock on one cpu
> >> but cpu which is checking value of OVL_METACOPY, really does not have
> >> any matching acquire/release or some other kind of barrier.
> >>
> >
> > Other CPU needs rmb before checking flag to guarantee the order
> > of setting METACOPY flag before setting upperdentry.
> >
> > If other CPU sees positive upperdentry and the METACOPY flag cleared,
> > then I *think* it should be safe to return the upper inode from d_real(),
> > because RELEASE on inode lock should have the proper guaranties
> > for consistency of inode data structures in memory.
> 
> Nah, smp_wmb before clearing METACOPY is correct, just like
> smp_wmb in ovl_inode_update(). probably should copy the same comment.

Atleast it feels safe (after reading memory-barrier.txt).

> But that was already there before this wrappers patch, so I don't see the
> need for this patch.

Actually, that was a patch organization mistake. I wanted to keep all
logic related to barriers around OVL_METACOPY flags in a single patch
with proper commit message. So that if later something is broken, we can
look at commit message and remember why did it do it this way.

Also, I thought doing this through wrapper functions makes lot of sense 
because it becomes easier to understand barrier pairing as well as chances
of making mistakes later come down. Very similar to wrappers used by
ovl_inode_update() and ovl_dentry_upper_dereference(). One can easily
understand what's the barrier pattern used here and what's being
protected.

So I really perfer to wrap barrier logic in wrappers. I will give this
patch series another try taking care of all other comments and then we
can have another round of conversation around this barrier logic.

Vivek
