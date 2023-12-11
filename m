Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAKGMVM+"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E42C3
	for <linux-unionfs@vger.kernel.org>; Mon, 11 Dec 2023 05:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702302399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=IFsLeKW3DW6BmxUhVRH0V3zQ/xj1O1MUYot7lQD78gA=;
	b=KAKGMVM+aaLG+Z/tHzo+nAYkQtFNFw0TxP/umL9W6adG//OUMcBdyHs2PIVSG91lOJyYnC
	EX6+zj706+EN2ZaBUzp7AHjDp7wXeE8pKM0/4Kohj8mjKmie+5VdQ29ubSrgDKzy/CW7go
	gl3hmagqCN9uFy1SSt+Vd8B/hFRb5Hw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-gwipvhcNOHqvkTvAlrfKrw-1; Mon, 11 Dec 2023 08:46:36 -0500
X-MC-Unique: gwipvhcNOHqvkTvAlrfKrw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c6459090baso3974603a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Dec 2023 05:46:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702302395; x=1702907195;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IFsLeKW3DW6BmxUhVRH0V3zQ/xj1O1MUYot7lQD78gA=;
        b=NPjqvzxiYUjIDp2//BaBs90Pu9NbsqgXJyzdHf4zFB/x72aQUpkG0hf3xJEYzRQ3+c
         i8O8uSfmU6wIcr8ob61mE9gAoiXNnUTGBZvQt8v4ldeQT82o01u9zu8iREMF6DKpoMk3
         YqtxvjS3QBp19G2NlgjrSGteVsLIXOIg4j8MjMfYmtjy0thTAjfjs1BNT+mfkpHpLAMs
         CbO3CWe+HIK/bNLRGe4P5t7t2w9k4QPgyD/BMjXnETC6Uc6ZXpDMP20WhKvv/PFflT+X
         L7r58jqjHZ7teSs4jLtmpAxxGixUoLVpbqpI4SZi1gq+UtnH1hshCx2tYuZRG66QxNN+
         CL+Q==
X-Gm-Message-State: AOJu0YyFfIuaGXPWNmR3BMc0iBzcPQEideYcRlazACp8uv0MsosOTzEx
	HfMQmevzWj9vixhK0XOOi5vZrYCRvcf2UVdghoELYY/kHx98j/LsVxN22wWH1bs4wqfGuQ+eslH
	fq/pOfK4xraK71EaBTZEyVF9l3qj6cEYN2MOqToHupA==
X-Received: by 2002:a05:6a20:1604:b0:190:3b35:5999 with SMTP id l4-20020a056a20160400b001903b355999mr6160555pzj.9.1702302395284;
        Mon, 11 Dec 2023 05:46:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz/VpW74q862C/8B1Zq9q8sq1pAy3bkDkccmDflRYHJXOso3iqCrr4R+jnoGZVXq44EchwL0IzwxnZXOgg+J8=
X-Received: by 2002:a05:6a20:1604:b0:190:3b35:5999 with SMTP id
 l4-20020a056a20160400b001903b355999mr6160548pzj.9.1702302394991; Mon, 11 Dec
 2023 05:46:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Eric Curtin <ecurtin@redhat.com>
Date: Mon, 11 Dec 2023 13:45:58 +0000
Message-ID: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
Subject: [RFC KERNEL] initoverlayfs - a scalable initial filesystem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org
Cc: Daan De Meyer <daan.j.demeyer@gmail.com>, Stephen Smoogen <ssmoogen@redhat.com>, 
	Yariv Rachmani <yrachman@redhat.com>, Daniel Walsh <dwalsh@redhat.com>, 
	Douglas Landgraf <dlandgra@redhat.com>, Alexander Larsson <alexl@redhat.com>, 
	Colin Walters <walters@redhat.com>, Brian Masney <bmasney@redhat.com>, 
	Eric Chanudet <echanude@redhat.com>, Pavol Brilla <pbrilla@redhat.com>, 
	Lokesh Mandvekar <lmandvek@redhat.com>, =?UTF-8?B?UGV0ciDFoGFiYXRh?= <psabata@redhat.com>, 
	Lennart Poettering <lennart@poettering.net>, Luca Boccassi <bluca@debian.org>, Neal Gompa <neal@gompa.dev>
Content-Type: text/plain; charset="UTF-8"

Hi All,

We have recently been working on something called initoverlayfs, which
we sent an RFC email to the systemd and dracut mailing lists to gather
feedback. This is an exploratory email as we are unsure if a solution
like this fits in userspace or kernelspace and we would like to gather
feedback from the community.

To describe this briefly, the idea is to use erofs+overlayfs as an
initial filesystem rather than an initramfs. The benefits are, we can
start userspace significantly faster as we do not have to unpack,
decompress and populate a tmpfs upfront, instead we can rely on
transparent decompression like lz4hc instead. What we believe is the
greater benefit, is that we can have less fear of initial filesystem
bloat, as when you are using transparent decompression you only pay
for decompressing the bytes you actually use.

We implemented the first version of this, by creating a small
initramfs that only contains storage drivers, udev and a couple of 100
lines of C code, just enough userspace to mount an erofs with
transient overlay. Then we build a second initramfs which has all the
contents of a normal everyday initramfs with all the bells and
whistles and convert this into an erofs.

Then at boot time you basically transition to this erofs+overlayfs in
userspace and everything works as normal as it would in a traditional
initramfs.

The current implementation looks like this:

```
From the filesystem perspective (roughly):

fw -> bootloader -> kernel -> mini-initramfs -> initoverlayfs -> rootfs

From the process perspective (roughly):

fw -> bootloader -> kernel -> storage-init   -> init ----------------->
```

But we have been asking the question whether we should be implementing
this in kernelspace so it looks more like:

```
From the filesystem perspective (roughly):

fw -> bootloader -> kernel -> initoverlayfs -> rootfs

From the process perspective (roughly):

fw -> bootloader -> kernel -> init ----------------->
```

The kind of questions we are asking are: Would it be possible to
implement this in kernelspace so we could just mount the initial
filesystem data as an erofs+overlayfs filesystem without unpacking,
decompressing, copying the data to a tmpfs, etc.? Could we memmap the
initramfs buffer and mount it like an erofs? What other considerations
should be taken into account?

Echo'ing Lennart we must also "keep in mind from the beginning how
authentication of every component of your process shall work" as
that's essential to a couple of different Linux distributions today.

We kept this email short because we want people to read it and avoid
duplicating information from elsewhere. The effort is described from
different perspectives in the systemd/dracut RFC email and github
README.md if you'd like to learn more, it's worth reading the
discussion in the systemd mailing list:

https://marc.info/?l=systemd-devel&m=170214639006704&w=2

https://github.com/containers/initoverlayfs/blob/main/README.md

We also received feedback informally in the community that it would be
nice if we could optionally use btrfs as an alternative.

Is mise le meas/Regards,

Eric Curtin

