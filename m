Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C973E7171
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 20:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543539; cv=none; b=AZTHe0KKBHAvofOMYRi6gVt172/nR/QWsknmqf4yOPDskC1D+dJV/p41oQDI8ON2YOlJCvIMUi2f7JkRf4q3fC0ar+VTkknd/G7z0VBXkoodIXUhr/PppwjJY6rFAkTDKQDAQtgyqg/YuMHKljsKS884bEzvf/S+r+NaaApCw9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543539; c=relaxed/simple;
	bh=HqIB2Kot+cSx6M46cVPe/gTQ8inr8AvF9kCYwuMxRpU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CcX31qfBuV1EbB76L6HNVYl1p/5e4nhBdwG3atfxqTEK9yM+ZWzli41RVRRYXAFOobunT55PcGM5oYgD2vLCLx4R4+Z9JHWEGDkxSyJlWdDiVJcO1/9EFI7sYXKldZU3c7e+5h3Wlmqvubmfx0OIB3UdaSdxjwy7Ez7H4YuIyC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edF0GqU8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edF0GqU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783543537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUGOXr6bxTzxRUQM7JAmFPIE9TMkzlb5J7p/wDZven8=;
	b=edF0GqU8ijGfTOktGZIoW8Snn0h8cGFb9mwUmC2Ul5kpxPtwqVXEBuW+i4SqaM1qOspTXY
	WM3HB5vx18vrYRH1wzF3KEldqxfPmPdsyTg7SDIyUcnZPNlCrSmrzZWiojos6OUQs30m9x
	9A9SuFFgkDWQpv9kaIJn3ArCbdqEmVM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-KDo1jjHIMWOaypUKFyLqkQ-1; Wed,
 08 Jul 2026 16:45:36 -0400
X-MC-Unique: KDo1jjHIMWOaypUKFyLqkQ-1
X-Mimecast-MFC-AGG-ID: KDo1jjHIMWOaypUKFyLqkQ_1783543535
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13B781800630;
	Wed,  8 Jul 2026 20:45:35 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 894853692D;
	Wed,  8 Jul 2026 20:45:34 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,  linux-unionfs@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-api@vger.kernel.org
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAJfpegvtd--TEQP9CVjSZuosU4meELdzhTV9oFo6joR1f4Dpgw@mail.gmail.com>
	(Miklos Szeredi's message of "Wed, 8 Jul 2026 16:01:38 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAOQ4uxiiVsp0BsdqfH3rCrpP6fBi-vTyfXd-TcVmFcS34MxzUQ@mail.gmail.com>
	<871pdd8ukx.fsf@redhat.com>
	<CAJfpegvtd--TEQP9CVjSZuosU4meELdzhTV9oFo6joR1f4Dpgw@mail.gmail.com>
Date: Wed, 08 Jul 2026 22:45:32 +0200
Message-ID: <87bjch6wib.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, 8 Jul 2026 at 15:44, Giuseppe Scrivano <gscrivan@redhat.com> wrot=
e:
>>
>> Amir Goldstein <amir73il@gmail.com> writes:
>>
>> > On Wed, Jul 8, 2026 at 2:31=E2=80=AFPM Giuseppe Scrivano <gscrivan@red=
hat.com> wrote:
>> >>
>> >> Miklos Szeredi <miklos@szeredi.hu> writes:
>> >>
>> >> > On Wed, 8 Jul 2026 at 12:00, Giuseppe Scrivano <gscrivan@redhat.com=
> wrote:
>> >> >>
>> >> >> Add two ioctls to overlay filesystem to allow userspace to retrieve
>> >> >> information about the overlay layers:
>> >> >>
>> >> >> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
>> >> >>                         arg =3D=3D 0 returns the upper layer (-ENO=
ENT if
>> >> >>                         no upper is configured), arg >=3D 1 returns
>> >> >>                         lower layers (-ENOENT if index is out of
>> >> >>                         range).
>> >> >
>> >> > We could do this with a plain open() call.  Something like the magic
>> >> > symlinks we have under /proc/PID/fd/.   Question is where could the=
se
>> >> > live...
>> >>
>> >> is there any existing user of such a mechanism?  I don't see any mount
>> >> specific info under /proc or /sys.
>> >>
>> >> >
>> >> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
>> >> >>                         with numlower, numlowerdata, and has_upper.
>> >> >
>> >> > Isn't this info obtainable via statmount(2) already?  If not, it
>> >> > should be there, instead of a specialized ioctl.
>> >>
>> >> no that is not exposed by statmount and I don't see any way to export
>> >> file system specific data through it.  Do you've anything in mind?
>> >>
>> >> >> --- a/fs/overlayfs/ovl_entry.h
>> >> >> +++ b/fs/overlayfs/ovl_entry.h
>> >> >> @@ -35,6 +35,8 @@ struct ovl_layer {
>> >> >>         struct vfsmount *mnt;
>> >> >>         /* Trap in ovl inode cache */
>> >> >>         struct inode *trap;
>> >> >> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_=
LAYER */
>> >> >> +       struct file *origin;
>> >> >
>> >> > Don't need to keep the file open: the only info missing is the
>> >> > original vfsmount, everything else is already there to reconstruct =
the
>> >> > file.
>> >>
>> >> I didn't manage to get that to work.  As soon as the userspace process
>> >> closes the mount fd that was passed to fsconfig, the anonymous mount
>> >> namespace is destroyed and dissolve_on_fput sets mnt->mnt_ns to NULL.
>> >>
>> >> So whenever I try to use this mount again from userspace, it is not
>> >> usable because the mount namespace is empty, causing check_mnt() to
>> >> fail.
>> >>
>> >> Do you have any suggestions on how to solve this problem?
>> >
>> > The suggestion was to store origin->f_path->mnt instead of storing ori=
gin file,
>> > because you only end up using the origin vfsmount.
>>
>> the reason I am keeping the file and not just the vfsmount is that the
>> file is what keeps the mount namespace alive (preventing
>> dissolve_on_fput from fire).
>>
>> Should we export open_detached_copy from fs/namespace.c?  I've not
>> tested it, but it might work.  Are there other ways to solve it that I
>> am not seeing?
>
> Using an anon namespace sounds good to me, that means the original
> vfsmount isn't needed at all.
>
> Not sure if it's okay for the case where the original ns is not anon,
> but we can save the vfsmount in that case if it turns out to be a
> problem.
>
> Thanks,
> Miklos

for this to work, I need something like:

diff --git a/fs/namespace.c b/fs/namespace.c
index 3d5cd5bf3b05..138d15ab37ef 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3091,6 +3091,52 @@ static struct file *open_detached_copy(struct path *=
path, unsigned int flags)
 	return file;
 }
=20
+struct file *open_detached_copy_internal(struct path *path)
+{
+	struct mnt_namespace *ns, *mnt_ns =3D current->nsproxy->mnt_ns;
+	struct mount *mnt;
+	struct file *file;
+
+	ns =3D alloc_mnt_ns(mnt_ns->user_ns, true);
+	if (IS_ERR(ns))
+		return ERR_CAST(ns);
+
+	guard(namespace_excl)();
+
+	mnt =3D clone_mnt(real_mount(path->mnt), path->dentry,
+			CL_COPY_MNT_NS_FILE);
+	if (IS_ERR(mnt)) {
+		free_mnt_ns(ns);
+		return ERR_CAST(mnt);
+	}
+
+	mnt_add_to_ns(ns, mnt);
+	ns->nr_mounts++;
+	ns->root =3D mnt;
+
+	mntput(path->mnt);
+	path->mnt =3D mntget(&mnt->mnt);
+	file =3D dentry_open(path, O_PATH, current_cred());
+	if (IS_ERR(file))
+		dissolve_on_fput(path->mnt);
+	else
+		file->f_mode |=3D FMODE_NEED_UNMOUNT;
+	return file;
+}
+EXPORT_SYMBOL_GPL(open_detached_copy_internal);
+
 enum mount_copy_flags_t {
 	MOUNT_COPY_RECURSIVE    =3D (1 << 0),
 	MOUNT_COPY_NEW		=3D (1 << 1),

is this acceptable?

Regards,
Giuseppe

