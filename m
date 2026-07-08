Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C625837F735
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518267; cv=none; b=OrzNRyYspApN/lk+3X+FMQMwTs3Di57pcrbdqK5z+tKyGQFAFKn7uz0FnZPT6T69dsSCgHrM8v8bhoG1TRO/dYPUmFRtrYTofCc8cUc929MrK3saG1ygAi0SI20Q9iKwvA44pX0+H/x3S7XhPu4JtyKgR0Vyyrdmcp4IejqH5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518267; c=relaxed/simple;
	bh=YsBaplu3SMyqS5ChwAscmwg7/sP4A3KtcN3vsRP2+do=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tfeA83bpcX7sjAHlck+LO1uS5ucV+GrIsNhBoKJP0M/3Rrmtd5TFQkc3p/xjotGo1NwjN7gDMXrtaWEcSDUdbW7mLsV2df4FsCPoVvq8k9JHY3dyGu8SkRiDpXwKLAmZZSaLVl+mhiHeXEYftFfaPghkbAdnQPlSxUuWM7/hXfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCYXOyDn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCYXOyDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783518264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MQQ1awMEWZQP75HQCTbVtUf+Uu2HSLb/C+A8UOw06U=;
	b=NCYXOyDnUxvJlV2LZlJFNSbhx0llEArqSVAULdMNShSzp6OBMVJmDzFVQqdUaC0sPbwL5y
	H3fe7qmeYkPZlPoGz/Cz7RbQ0fZCdk6nNhd/OkiFhLWtxIt+ZSP23/QmqQQXY2tyhfnxSr
	5fCRz0zBqE8GhjIqaAbBJOLxAscNkNI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-koEbMCitOZKS5lRLZMc2EQ-1; Wed,
 08 Jul 2026 09:44:19 -0400
X-MC-Unique: koEbMCitOZKS5lRLZMc2EQ-1
X-Mimecast-MFC-AGG-ID: koEbMCitOZKS5lRLZMc2EQ_1783518258
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F56A19560B7;
	Wed,  8 Jul 2026 13:44:18 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54FEC1800591;
	Wed,  8 Jul 2026 13:44:17 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  linux-unionfs@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-api@vger.kernel.org
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAOQ4uxiiVsp0BsdqfH3rCrpP6fBi-vTyfXd-TcVmFcS34MxzUQ@mail.gmail.com>
	(Amir Goldstein's message of "Wed, 8 Jul 2026 15:23:46 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAOQ4uxiiVsp0BsdqfH3rCrpP6fBi-vTyfXd-TcVmFcS34MxzUQ@mail.gmail.com>
Date: Wed, 08 Jul 2026 15:44:14 +0200
Message-ID: <871pdd8ukx.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Amir Goldstein <amir73il@gmail.com> writes:

> On Wed, Jul 8, 2026 at 2:31=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat=
.com> wrote:
>>
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>>
>> > On Wed, 8 Jul 2026 at 12:00, Giuseppe Scrivano <gscrivan@redhat.com> w=
rote:
>> >>
>> >> Add two ioctls to overlay filesystem to allow userspace to retrieve
>> >> information about the overlay layers:
>> >>
>> >> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
>> >>                         arg =3D=3D 0 returns the upper layer (-ENOENT=
 if
>> >>                         no upper is configured), arg >=3D 1 returns
>> >>                         lower layers (-ENOENT if index is out of
>> >>                         range).
>> >
>> > We could do this with a plain open() call.  Something like the magic
>> > symlinks we have under /proc/PID/fd/.   Question is where could these
>> > live...
>>
>> is there any existing user of such a mechanism?  I don't see any mount
>> specific info under /proc or /sys.
>>
>> >
>> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
>> >>                         with numlower, numlowerdata, and has_upper.
>> >
>> > Isn't this info obtainable via statmount(2) already?  If not, it
>> > should be there, instead of a specialized ioctl.
>>
>> no that is not exposed by statmount and I don't see any way to export
>> file system specific data through it.  Do you've anything in mind?
>>
>> >> --- a/fs/overlayfs/ovl_entry.h
>> >> +++ b/fs/overlayfs/ovl_entry.h
>> >> @@ -35,6 +35,8 @@ struct ovl_layer {
>> >>         struct vfsmount *mnt;
>> >>         /* Trap in ovl inode cache */
>> >>         struct inode *trap;
>> >> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_LAY=
ER */
>> >> +       struct file *origin;
>> >
>> > Don't need to keep the file open: the only info missing is the
>> > original vfsmount, everything else is already there to reconstruct the
>> > file.
>>
>> I didn't manage to get that to work.  As soon as the userspace process
>> closes the mount fd that was passed to fsconfig, the anonymous mount
>> namespace is destroyed and dissolve_on_fput sets mnt->mnt_ns to NULL.
>>
>> So whenever I try to use this mount again from userspace, it is not
>> usable because the mount namespace is empty, causing check_mnt() to
>> fail.
>>
>> Do you have any suggestions on how to solve this problem?
>
> The suggestion was to store origin->f_path->mnt instead of storing origin=
 file,
> because you only end up using the origin vfsmount.

the reason I am keeping the file and not just the vfsmount is that the
file is what keeps the mount namespace alive (preventing
dissolve_on_fput from fire).

Should we export open_detached_copy from fs/namespace.c?  I've not
tested it, but it might work.  Are there other ways to solve it that I
am not seeing?

Thanks,
Giuseppe

