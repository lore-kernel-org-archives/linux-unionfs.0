From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v7] ovl: Improving syncfs efficiency
Date: Fri, 26 Jan 2018 11:02:03 +0800
Message-ID: <35D4AADF-5812-4F73-AF09-49E732B5F4A3@icloud.com>
References: <1516872955-10069-1-git-send-email-cgxu519@icloud.com>
 <20180125143250.7vulbi2ytxmgk7fu@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:43420 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAZDCT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:02:19 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P3500E007278U00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Fri, 26 Jan 2018 03:02:13 +0000 (GMT)
In-reply-to: <20180125143250.7vulbi2ytxmgk7fu@quack2.suse.cz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org

Hi Jan

Thanks for your comments, I have some questions below.



> =D4=DA 2018=C4=EA1=D4=C225=C8=D5=A3=AC=CF=C2=CE=E710:32=A3=ACJan Kara =
<jack@suse.cz> =D0=B4=B5=C0=A3=BA
>=20
> On Thu 25-01-18 17:35:55, Chengguang Xu wrote:
>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>> regardless of the overlay ownership of the inode. In the use case of
>> container, when multiple containers using the same underlying upper
>> filesystem, it has some shortcomings as below.
>>=20
>> (1) Performance
>> Synchronization is probably heavy because it actually syncs =
unnecessary
>> inodes for target overlayfs.
>>=20
>> (2) Interference
>> Unplanned synchronization will probably impact IO performance of
>> unrelated container processes on the other overlayfs.
>>=20
>> This patch iterates upper inode list in overlayfs to only sync target
>> dirty inodes and wait for completion. By doing this, It is able to =
reduce
>> cost of synchronization and will not seriously impact IO performance =
of
>> unrelated processes. In special case, when having very few dirty =
inodes
>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>> time so that synchronization is slower than before, but we think the
>> potential for performance improvement far surpass the potential for
>> performance regression in most cases.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>=20
> This looks much better than the last version I've reviewed! Good work. =
Just
> some small comments below.
>=20
>> +void ovl_evict_inode(struct inode *inode)
>> +{
>> +	if (ovl_inode_upper(inode)) {
>> +		write_inode_now(ovl_inode_upper(inode), 1);
>> +		ovl_detach_upper_inodes_list(inode);
>> +
>> +		/*
>> +		 * ovl_sync_inodes() may wait until
>> +		 * flag OVL_EVICT_PENDING to be cleared.
>> +		 */
>> +		spin_lock(&inode->i_lock);
>> +		ovl_clear_flag(OVL_EVICT_PENDING, inode);
>> +		/* See also atomic_bitops.txt */
>> +		smp_mb__after_atomic();
>> +		wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
>> +		spin_unlock(&inode->i_lock);
>> +		clear_inode(inode);
>> +	}
>> +}
>> +
>> +void ovl_wait_evict_pending(struct inode *inode)
>> +{
>> +	struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
>> +	struct ovl_inode *oi =3D OVL_I(inode);
>> +	DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
>> +	wait_queue_head_t *wqh;
>> +	bool sleep;
>> +
>> +	if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
>=20
> AFAIU your code OVL_EVICT_PENDING should be always set when this =
function
> is called. Maybe just make a WARN_ON from this condition?

OK, I=A1=AFll add.

>=20
>> +		wqh =3D bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
>> +		prepare_to_wait(wqh, &wait.wq_entry, =
TASK_UNINTERRUPTIBLE);
>> +		sleep =3D ovl_test_flag(OVL_EVICT_PENDING, inode);

I think we also don=A1=AFt have to check sleep again here because before =
unlock
ofs->upper_inodes_lock OVL_EVICT_PENDING will not be cleared.=20

>> +		spin_unlock(&inode->i_lock);
>> +		spin_unlock(&ofs->upper_inodes_lock);
>> +		if (sleep)
>> +			schedule();
>> +		finish_wait(wqh, &wait.wq_entry);
>> +	}
>> +}
>> +
>> +/**
>> + * ovl_sync_inodes
>> + * @sb: The overlayfs super block
>> + *
>> + * upper_inodes list is used for organizing ovl inode which has =
upper inode,
>> + * by iterating the list to looking for and syncing dirty upper =
inode.
>> + *
>> + * When starting syncing inode, we add the inode to wait list =
explicitly,
>> + * in order to save memory we reuse inode->i_wb_list and =
sb->s_inodes_wb,
>> + * so those fields have slightly differnt meanings in overlayfs.
>> + */
>> +static void ovl_sync_inodes(struct super_block *sb)
>> +{
>> +	struct ovl_fs *ofs =3D sb->s_fs_info;
>> +	struct ovl_inode *oi;
>> +	struct inode *inode;
>> +	struct inode *upper_inode;
>> +	struct blk_plug plug;
>> +	LIST_HEAD(sync_tmp_list);
>> +
>> +	struct writeback_control wbc_for_sync =3D {
>> +		.sync_mode		=3D WB_SYNC_ALL,
>> +		.for_sync		=3D 1,
>> +		.range_start		=3D 0,
>> +		.range_end		=3D LLONG_MAX,
>> +		.nr_to_write		=3D LONG_MAX,
>> +	};
>> +
>> +	blk_start_plug(&plug);
>> +	spin_lock(&ofs->upper_inodes_lock);
>> +	list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
>> +
>> +	while (!list_empty(&sync_tmp_list)) {
>> +		oi =3D list_first_entry(&sync_tmp_list, struct =
ovl_inode,
>> +						upper_inodes_list);
>> +		inode =3D &oi->vfs_inode;
>> +		spin_lock(&inode->i_lock);
>> +
>> +		list_move_tail(&oi->upper_inodes_list, =
&ofs->upper_inodes);
>> +		if (inode->i_state & I_NEW) {
>> +			spin_unlock(&inode->i_lock);
>> +			continue;
>> +		}
>> +
>> +		/*
>> +		 * If ovl inode state is I_FREEING,
>> +		 * left sync operation to the ovl_evict_inode(),
>> +		 * so wait here until OVL_EVICT_PENDING flag to be =
cleared.
>> +		 */
>> +		if (inode->i_state & I_FREEING) {
>> +			ovl_wait_evict_pending(inode);
>=20
> This is still somewhat racy. The problem is that a wakeup in
> ovl_wait_evict_pending() can come from all sorts of reasons. You are =
not
> guaranteed OVL_EVICT_PENDING is cleared when you are woken up. You =
cannot
> easily recheck the flag as the inode *may* really be free by this =
time.

I think DEFINE_WAIT_BIT can wakeup sleeping thread only for right reason =
and
there is no other place to set OVL_EVICT_PENDING again. IIUC, we don=A1=AF=
t have
to check OVL_EVICT_PENDING in a loop. Am I missing something?


> What I'd do to fix this race is not to move inode with =
OVL_EVICT_PENDING to
> the tail of ofs->upper_inodes but just keep it in &sync_tmp_list. That =
way
> we are sure that either the inode gets freed (thus removed from
> &sync_tmp_list) and we'll never see it again, or we'll again see it in
> &sync_tmp_list, see again OVL_EVICT_PENDING, and wait again for it =
which is
> what we need.

If my analysis above is not correct, I=A1=AFll modify as your suggestion =
here.



>=20
>> +			goto next;
>> +		}
>> +
>> +		ihold(inode);
>> +		upper_inode =3D ovl_inode_upper(inode);
>> +		spin_unlock(&inode->i_lock);
>> +		spin_unlock(&ofs->upper_inodes_lock);
>> +
>> +		if (!(upper_inode->i_state & I_DIRTY_ALL)) {
>> +			if (!mapping_tagged(upper_inode->i_mapping,
>> +						=
PAGECACHE_TAG_WRITEBACK)) {
>> +				iput(inode);
>> +				goto next;
>> +			}
>> +		} else {
>> +			sync_inode(upper_inode, &wbc_for_sync);
>> +		}
>> +
>> +		spin_lock(&sb->s_inode_wblist_lock);
>> +		list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
>> +		spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +next:
>> +		if (need_resched()) {
>> +			blk_finish_plug(&plug);
>=20
> Plug is automatically unplugged when scheduling so no need for
> blk_finish_plug() here.
>=20
>> +			cond_resched();
>> +			blk_start_plug(&plug);
>> +		}
>=20
> Also
> 	if (need_resched())
> 		cond_resched();
> is equivalent to just
> 	cond_resched();
>=20
> so you can just do that here.

I will fix.

>=20
>> +		spin_lock(&ofs->upper_inodes_lock);
>> +	}
>> +	spin_unlock(&ofs->upper_inodes_lock);
>> +	blk_finish_plug(&plug);
>> +}
>> +
>> +/**
>> + * ovl_wait_inodes
>> + * @sb: The overlayfs super block
>> + *
>> + * Waiting writeback inodes which are in s_inodes_wb list,
>> + * all the IO that has been issued up to the time this
>> + * function is enter is guaranteed to be completed.
>> + */
>> +static void ovl_wait_inodes(struct super_block *sb)
>> +{
>> +	LIST_HEAD(sync_wait_list);
>> +	struct inode *inode;
>> +	struct inode *upper_inode;
>> +
>> +	/*
>> +	 * ovl inode in sb->s_inodes_wb list has already got inode =
reference,
>> +	 * this will avoid silent inode droping during waiting on it.
>> +	 *
>> +	 * Splice the sync wait list onto a temporary list to avoid =
waiting on
>> +	 * inodes that have started writeback after this point.
>> +	 */
>> +	spin_lock(&sb->s_inode_wblist_lock);
>> +	list_splice_init(&sb->s_inodes_wb, &sync_wait_list);
>> +
>> +	while (!list_empty(&sync_wait_list)) {
>> +		inode =3D list_first_entry(&sync_wait_list, struct =
inode,
>> +							i_wb_list);
>> +		list_del_init(&inode->i_wb_list);
>> +		upper_inode =3D ovl_inode_upper(inode);
>> +		spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +		if (!mapping_tagged(upper_inode->i_mapping,
>> +				PAGECACHE_TAG_WRITEBACK)) {
>> +			goto next;
>> +		}
>> +
>> +		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
>> +
>> +		if (need_resched())
>> +			cond_resched();
>=20
> Again, just cond_resched() is enough here.

I will fix.


Thanks,
Chengguang.
