From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v7] ovl: Improving syncfs efficiency
Date: Mon, 29 Jan 2018 16:33:11 +0800
Message-ID: <31E4CB1A-2B7F-4C60-BD01-8A045250A20C@icloud.com>
References: <1516872955-10069-1-git-send-email-cgxu519@icloud.com>
 <20180125143250.7vulbi2ytxmgk7fu@quack2.suse.cz>
 <35D4AADF-5812-4F73-AF09-49E732B5F4A3@icloud.com>
 <20180126160828.ytgyyml2lxztsehg@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:46940 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeA2Id2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 Jan 2018 03:33:28 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P3B00J006EW3D00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 29 Jan 2018 08:33:21 +0000 (GMT)
In-reply-to: <20180126160828.ytgyyml2lxztsehg@quack2.suse.cz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, amir73il@gmail.com, linux-unionfs@vger.kernel.org

>=20
> =D4=DA 2018=C4=EA1=D4=C227=C8=D5=A3=AC=C9=CF=CE=E712:08=A3=ACJan Kara =
<jack@suse.cz> =D0=B4=B5=C0=A3=BA
>=20
> Hi Chengguang!
>=20
> On Fri 26-01-18 11:02:03, Chengguang Xu wrote:
>>> AFAIU your code OVL_EVICT_PENDING should be always set when this =
function
>>> is called. Maybe just make a WARN_ON from this condition?
>>=20
>> OK, I=A1=AFll add.
>>=20
>>>=20
>>>> +		wqh =3D bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
>>>> +		prepare_to_wait(wqh, &wait.wq_entry, =
TASK_UNINTERRUPTIBLE);
>>>> +		sleep =3D ovl_test_flag(OVL_EVICT_PENDING, inode);
>>=20
>> I think we also don=A1=AFt have to check sleep again here because =
before unlock
>> ofs->upper_inodes_lock OVL_EVICT_PENDING will not be cleared.=20
>=20
> I'm not sure what you are suggesting here - i.e., where do you think =
you are
> checking the 'sleep' again?

Hi Jan,

In new version I changed to keep ovl_inode with OVL_EVICT_PENDING in =
&sync_tmp_list
and simply continue the main loop, by doing this I think we can simplify =
the check in
ovl_wait_evict_pending(). This seems the simplest way to me.

Thanks,
Chengguang.


>=20
>>>> +		spin_unlock(&inode->i_lock);
>>>> +		spin_unlock(&ofs->upper_inodes_lock);
>>>> +		if (sleep)
>>>> +			schedule();
>>>> +		finish_wait(wqh, &wait.wq_entry);
>>>> +	}
>>>> +}
>>>> +
>>>> +/**
>>>> + * ovl_sync_inodes
>>>> + * @sb: The overlayfs super block
>>>> + *
>>>> + * upper_inodes list is used for organizing ovl inode which has =
upper inode,
>>>> + * by iterating the list to looking for and syncing dirty upper =
inode.
>>>> + *
>>>> + * When starting syncing inode, we add the inode to wait list =
explicitly,
>>>> + * in order to save memory we reuse inode->i_wb_list and =
sb->s_inodes_wb,
>>>> + * so those fields have slightly differnt meanings in overlayfs.
>>>> + */
>>>> +static void ovl_sync_inodes(struct super_block *sb)
>>>> +{
>>>> +	struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> +	struct ovl_inode *oi;
>>>> +	struct inode *inode;
>>>> +	struct inode *upper_inode;
>>>> +	struct blk_plug plug;
>>>> +	LIST_HEAD(sync_tmp_list);
>>>> +
>>>> +	struct writeback_control wbc_for_sync =3D {
>>>> +		.sync_mode		=3D WB_SYNC_ALL,
>>>> +		.for_sync		=3D 1,
>>>> +		.range_start		=3D 0,
>>>> +		.range_end		=3D LLONG_MAX,
>>>> +		.nr_to_write		=3D LONG_MAX,
>>>> +	};
>>>> +
>>>> +	blk_start_plug(&plug);
>>>> +	spin_lock(&ofs->upper_inodes_lock);
>>>> +	list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
>>>> +
>>>> +	while (!list_empty(&sync_tmp_list)) {
>>>> +		oi =3D list_first_entry(&sync_tmp_list, struct =
ovl_inode,
>>>> +						upper_inodes_list);
>>>> +		inode =3D &oi->vfs_inode;
>>>> +		spin_lock(&inode->i_lock);
>>>> +
>>>> +		list_move_tail(&oi->upper_inodes_list, =
&ofs->upper_inodes);
>>>> +		if (inode->i_state & I_NEW) {
>>>> +			spin_unlock(&inode->i_lock);
>>>> +			continue;
>>>> +		}
>>>> +
>>>> +		/*
>>>> +		 * If ovl inode state is I_FREEING,
>>>> +		 * left sync operation to the ovl_evict_inode(),
>>>> +		 * so wait here until OVL_EVICT_PENDING flag to be =
cleared.
>>>> +		 */
>>>> +		if (inode->i_state & I_FREEING) {
>>>> +			ovl_wait_evict_pending(inode);
>>>=20
>>> This is still somewhat racy. The problem is that a wakeup in
>>> ovl_wait_evict_pending() can come from all sorts of reasons. You are =
not
>>> guaranteed OVL_EVICT_PENDING is cleared when you are woken up. You =
cannot
>>> easily recheck the flag as the inode *may* really be free by this =
time.
>>=20
>> I think DEFINE_WAIT_BIT can wakeup sleeping thread only for right =
reason and
>> there is no other place to set OVL_EVICT_PENDING again. IIUC, we =
don=A1=AFt have
>> to check OVL_EVICT_PENDING in a loop. Am I missing something?
>=20
> You are correct that wake_up_bit() will only wake up process once it =
has
> cleared the bit. But there can be other wake up sources like signal
> delivery so you cannot assume you will get woken only after the inode =
is
> gone...
>=20
>>> What I'd do to fix this race is not to move inode with =
OVL_EVICT_PENDING to
>>> the tail of ofs->upper_inodes but just keep it in &sync_tmp_list. =
That way
>>> we are sure that either the inode gets freed (thus removed from
>>> &sync_tmp_list) and we'll never see it again, or we'll again see it =
in
>>> &sync_tmp_list, see again OVL_EVICT_PENDING, and wait again for it =
which is
>>> what we need.
>>=20
>> If my analysis above is not correct, I=A1=AFll modify as your =
suggestion here.
>=20
> Please do.
>=20
> 								Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
