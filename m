Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B873BBA1C
	for <linux-unionfs@vger.kernel.org>; Thu, 15 Jan 2026 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493262; cv=none; b=g/n8eVFvYXlVIcuYQzlH9p//Hf6g7zJdZtax2sAqHRnlybzRGDV69Agc7d+zGSL5wJS/0R3+MJSyhsSIaUu6cmaOlehH98YnX4p3UQ1EzJMI/GbrhDoMrr1BUMqZJwE8l/K4TWfUqkmhS4Opze+NvpKe1RGa4ujFsdmwlWUvs5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493262; c=relaxed/simple;
	bh=x596PaRllNdpIS5h9hbxK5VONKk86ckOfrPn2xRuoYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rI9giCEYQYwck2BY2ZDgPjcLis62EBx9ftl2636t5amExlpdDIlDnC4N2JzFPecgEFtp3hIj3/61bpWL3LjLEVe+QnLqxPkAqg6gCiJmiCgHroe4Iqtc1iwO+qCURsNA1zIc8x6H5xZft4pNfmvoUtOAxj34+J+LZqnbmbZPUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VxkV/2AH; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VxkV/2AH"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-432d2c96215so927150f8f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jan 2026 08:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768493256; x=1769098056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bL4KgiUjakccFp8GDyIgH1rXwphyq4QxNLCwr+nqA/M=;
        b=VxkV/2AHa5JQBaAQICa5sas+eHcjykHVbERA704p8HnhoB2mMgb2rXtLkj//IoI3AC
         btn2Bo5JoPN2LhEwuy2ibPdWaRYrkxUqhWKpHXYu25u25lBKAdozXbYixKpAMtZ02Slu
         JDCQ+F2JeKsgrI2ECJhZmapjAM6rD1QMf0a1zcDwvvTHhTF/e4Grrujl3C0HJWL/fueg
         zchtSCwwaxIcmPAZlJqJGfqrQOC37L/Efl7Qg+KF2AnkfZtpGUdhgm+mw96D5jkAgJcR
         k3Kyx1PWB8XnuzwCmwkhZdLLB5YFkYUOgi1FOGKxlbpnPHLOvuZnm5rPR8enVS/t8dJz
         t8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768493256; x=1769098056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bL4KgiUjakccFp8GDyIgH1rXwphyq4QxNLCwr+nqA/M=;
        b=v8g0ysWethm7rjh9P+T07LF9zbPBxPI+RKedErrml9c9ODd1gYietX0U0liiV1lUm9
         0lBcz5CpaU1xt8vUG4Hx6KmF+JiejuVYUZO+rMDXuIgY1MAGKAmQ/5+hKIgg14l1Ka1e
         Qn5+OTUlGV493xY8Z6zZ2fiYSMO0CSEwYB9wWNwvK65Ikj8+1oGaaamXTm9L62P+T3py
         CHihX3QoOpUKjNXqPZ0kBsaEGOwC0HERWaiKlmzFkM93QrommkI7VZ1Vyg/LCQwILMSd
         kp+nsAPfSbp1+N1amy57jJSEqsKq5cNWQTjCoZ0qYccUr+EoTLYNY9IBl20o8lQCFjYX
         9hKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJyi5tkiziQZCrSDeRcJNTr4fK27XSTkOauGG/cgziM4Uikiu6K3p9zB1qdx8ug7f3msJMlOmNRqGUmknh@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2hV0UfokcvJlKTBYbfqyjKwxAtZ6/e8JNg8Fv3fAjtRK5eSUZ
	YHp4vmmx0V0h7bfBVbjtvxaLalKvYYKUDvEDSbcAXR4cworsRjTq0qUKb1riGfjxBGEWUpIzmF9
	s8ylcV01Np8T9XcRRMtdPxMFZaDEN7K4=
X-Gm-Gg: AY/fxX4iUWeHGS59MjPBGzLwxigA96HpVMudr5XmDtmdDpPVFdEMjWMATjBoro5TzOx
	0TAK8fwOPstPfOgMrN6ebw063Ph26SyAvPPNvR9YcyWTFvSgWLkq7AaUi0q0B87mhDzUX0QV9NT
	PZr2NRVmTQgHwr4wMDa72b3Q2hQUQmJu+T9WEV30sYyhJT2dvnNHnGM6CDbprfKBbHcFYeicdhm
	e/Z+DR6xobzGdm7a5loaNoy5RE8MnYN74dJtM4rBQxj9JynWosJg+XyLzgW1evGjPFnVxvBMF8G
	tQ6RgrRIykzJe+a7sFKz0qj8qB3Fnw==
X-Received: by 2002:a05:6000:2303:b0:42f:a025:92b3 with SMTP id
 ffacd0b85a97d-4342d3895a7mr7282018f8f.2.1768493256065; Thu, 15 Jan 2026
 08:07:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
 <20260114062608.GB10805@lst.de> <5334ebc6-ceee-4262-b477-6b161c5ca704@igalia.com>
 <20260115062944.GA9590@lst.de> <633bb5f3-4582-416c-b8b9-fd1f3b3452ab@suse.com>
 <20260115072311.GA10352@lst.de> <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
In-Reply-To: <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 17:07:24 +0100
X-Gm-Features: AZwV_QiiOfVz5MjHOOW7TnQI8q-5ZkSKoahnBApAROcQQgB7iPXfsZHV_rRz004
Message-ID: <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 4:42=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Em 15/01/2026 04:23, Christoph Hellwig escreveu:
>
> [...]
>
> >
> > I still wonder what the use case is here.  Looking at Andr=C3=A9's orig=
inal
> > mail it states:
> >
> > "However, btrfs mounts may have volatiles UUIDs. When mounting the exac=
t same
> > disk image with btrfs, a random UUID is assigned for the following disk=
s each
> > time they are mounted, stored at temp_fsid and used across the kernel a=
s the
> > disk UUID. `btrfs filesystem show` presents that. Calling statfs() howe=
ver
> > shows the original (and duplicated) UUID for all disks."
> >
> > and this doesn't even talk about multiple mounts, but looking at
> > device_list_add it seems to only set the temp_fsid flag when set
> > same_fsid_diff_dev is set by find_fsid_by_device, which isn't documente=
d
> > well, but does indeed seem to be done transparently when two file syste=
ms
> > with the same fsid are mounted.
> >
> > So Andr=C3=A9, can you confirm this what you're worried about?  And btr=
fs
> > developers, I think the main problem is indeed that btrfs simply allows
> > mounting the same fsid twice.  Which is really fatal for anything using
> > the fsid/uuid, such NFS exports, mount by fs uuid or any sb->s_uuid use=
r.
> >
>
> Yes, I'm would like to be able to mount two cloned btrfs images and to
> use overlayfs with them. This is useful for SteamOS A/B partition scheme.
>
> >> If so, I think it's time to revert the behavior before it's too late.
> >> Currently the main usage of such duplicated fsids is for Steam deck to
> >> maintain A/B partitions, I think they can accept a new compat_ro flag =
for
> >> that.
> >
> > What's an A/B partition?  And how are these safely used at the same tim=
e?
> >
>
> The Steam Deck have two main partitions to install SteamOS updates
> atomically. When you want to update the device, assuming that you are
> using partition A, the updater will write the new image in partition B,
> and vice versa. Then after the reboot, the system will mount the new
> image on B.
>

And what do you expect to happen wrt overlayfs when switching from
image A to B?

What are the origin file handles recorded in overlayfs index from image A
lower worth when the lower image is B?

Is there any guarantee that file handles are relevant and point to the
same objects?

The whole point of the overlayfs index feature is that overlayfs inodes
can have a unique id across copy-up.

Please explain in more details exactly which overlayfs setup you are
trying to do with index feature.

FWIW, the setup you are describing sounds very familiar.
I am pretty sure that a similar setup with squashfs and OpenWRT [1]
was the use case to add the uuid=3Doff overlayfs mount options.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
