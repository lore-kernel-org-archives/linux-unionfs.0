Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFBB35CBAC
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Jan 2026 09:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768557334; cv=none; b=WOJareo4F54j8JiJqCI53cWeJfTAGgvr00iGo4cuBmtRb88kZKH7F73j0r37jg+UCVCRHDr6gPU0xTo6pjilwsncHCok0K4ZTQM0lMXStvDgG4R4qE2AuChp/mqRlC1KtulDzLsznCsi0hEaVpJe8pxUI+DMDUrzH0LMeYBuxjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768557334; c=relaxed/simple;
	bh=K1IVhgLVP4tMWa4rCPNyc3P/DTHNpSOZNTFwb25LilA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bs9wqJuNdacYvERHf6aKUPvSoa1zQ95kBHyh2NXhfujpwFL9D+EiieWevCyrRwndQYMI+S7dH9ODlHMJjPEyILx2L/0w2pq0KlwG6A89+OeTawfTuD5ZGsnukHRHm+unKX4cJvx2sc3UWWwtKeGzSMRI6bm3SFkraLbmJxl5RV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tu3uI3Ls; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tu3uI3Ls"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso2830972a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jan 2026 01:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768557328; x=1769162128; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4xFyXf1g1QrEuF2V9wAvkuU4l5f69A6f1eeQe7d3g4=;
        b=Tu3uI3LsJHfm6sNIcneQu2bYQa5YkZemeRhVLiWhyUpDatM1CaaXJ5Kqy9qakFPHU8
         19Yz0tvzaUgaLz2XacmRn2m9dK5Wi6d4SkcGT/mAGUhc4O3CLIyWdzFyM7pZeMEVZL1c
         zxJDSEym/iUbaM3nehfogYSXexEELdRnrBbDspaIjOQseheo0FQR1vDSOUR+aZsMv78P
         gSniwcsF4KoxAijuRf8ykfpVSjBSgz/h5Wc45prDz7ym4N9qZp5PjkDorEu84ilphDfJ
         AwyztpbmX22k0BqFS8dH13sn/yCuN2nYlYn7eUy2htkLJ8Lli8JGYeMoY5Gs7/rQT5Zz
         m7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768557328; x=1769162128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J4xFyXf1g1QrEuF2V9wAvkuU4l5f69A6f1eeQe7d3g4=;
        b=nIhjZAa/Xi0/K2LrD5gNsVSvbBatZr/xV7A8hOiauXBFoX2Upnhb03XumyeqKCIePz
         DFzR3dRTbcD53gpSx3NGIJy+dETG+f4aocnox9FGJf07FVyCrUoQNwvaZJlP4u2ikna7
         7vk0F23R/9QVqi7tQyLy1Wb0gKjt6KpscyF3L4AruYhpJiJGCFl8hT2g/EzckFJA8hoX
         VIgq6UtPOYuhASuQlFiYqqSBl6dTyu28Uda+LT2CdFKphmcga9ZspbaNMtEhnd6X8zAY
         /f2w49r3BcBagMQsnvaAFXh1V1fmCgJX5NnrJB3SfbErsb3zFYAZCY4Qq0W/RNwaoywM
         w1yw==
X-Forwarded-Encrypted: i=1; AJvYcCVCs/FDI9l7e04lmXemXKkzrIJ48BtTF+N8NciSnbiipFcC0G/A8qox9m8DS2YnoMVXcVud4dmXK5sT+oSx@vger.kernel.org
X-Gm-Message-State: AOJu0YzHKiGsA4MNUOkSNSknemFCwIDpHxdRjyvQhquhhoAaR6USKbJN
	6zQUGocIRAig3/dxkQjj8lpx+QjzM1bQPL+RU0NaF/ZNCvXiMP5BjaF5rsQcv7jSmZp37RY+7Fu
	YLQrQMJfPQVXNWElwQP+XV5R1W+Tk04s=
X-Gm-Gg: AY/fxX4tL7rZcl3VdU8FT1Ok51iW90yUWLy28doOVdLfZk3SDyfJrY0i9+ZpLx0r33i
	JJkjX8P3r9rks9aCB9KoDAfEHnjn36ddMRwCTumu0QqTDT6V+bhJ8cADMI/r6S/cnTB+tn1d4MF
	JaN08Bl/GwKu3RcMv5dUj/HKDWtT2cXyqHbCz084ITZDWKU/zjwUqfo28unZkarureVhc72ZUud
	9vh8YRJM7FewMeXTWuAqHaHNFi81zhC9TTtiDKVq7FzQMyqNkELy1lKjlMBzwg+PyxnMITjKU4V
	2qi7zE3QtS5bPp77cv4SzLsof2zXnQ==
X-Received: by 2002:a05:6402:399a:b0:64b:6e20:c92e with SMTP id
 4fb4d7f45d1cf-654526c9083mr1397349a12.10.1768557327690; Fri, 16 Jan 2026
 01:55:27 -0800 (PST)
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
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com> <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com>
In-Reply-To: <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Jan 2026 10:55:15 +0100
X-Gm-Features: AZwV_Qi6NnVcLeZQhugqg4vwwjzqnBqiBj0Y0tKNZxo4ZfD1WtvuLTyqSS9dynY
Message-ID: <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
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

On Thu, Jan 15, 2026 at 7:55=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Em 15/01/2026 13:07, Amir Goldstein escreveu:
> > On Thu, Jan 15, 2026 at 4:42=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid=
@igalia.com> wrote:
> >>
> >> Em 15/01/2026 04:23, Christoph Hellwig escreveu:
> >>
> >> [...]
> >>
> >>>
> >>> I still wonder what the use case is here.  Looking at Andr=C3=A9's or=
iginal
> >>> mail it states:
> >>>
> >>> "However, btrfs mounts may have volatiles UUIDs. When mounting the ex=
act same
> >>> disk image with btrfs, a random UUID is assigned for the following di=
sks each
> >>> time they are mounted, stored at temp_fsid and used across the kernel=
 as the
> >>> disk UUID. `btrfs filesystem show` presents that. Calling statfs() ho=
wever
> >>> shows the original (and duplicated) UUID for all disks."
> >>>
> >>> and this doesn't even talk about multiple mounts, but looking at
> >>> device_list_add it seems to only set the temp_fsid flag when set
> >>> same_fsid_diff_dev is set by find_fsid_by_device, which isn't documen=
ted
> >>> well, but does indeed seem to be done transparently when two file sys=
tems
> >>> with the same fsid are mounted.
> >>>
> >>> So Andr=C3=A9, can you confirm this what you're worried about?  And b=
trfs
> >>> developers, I think the main problem is indeed that btrfs simply allo=
ws
> >>> mounting the same fsid twice.  Which is really fatal for anything usi=
ng
> >>> the fsid/uuid, such NFS exports, mount by fs uuid or any sb->s_uuid u=
ser.
> >>>
> >>
> >> Yes, I'm would like to be able to mount two cloned btrfs images and to
> >> use overlayfs with them. This is useful for SteamOS A/B partition sche=
me.
> >>
> >>>> If so, I think it's time to revert the behavior before it's too late=
.
> >>>> Currently the main usage of such duplicated fsids is for Steam deck =
to
> >>>> maintain A/B partitions, I think they can accept a new compat_ro fla=
g for
> >>>> that.
> >>>
> >>> What's an A/B partition?  And how are these safely used at the same t=
ime?
> >>>
> >>
> >> The Steam Deck have two main partitions to install SteamOS updates
> >> atomically. When you want to update the device, assuming that you are
> >> using partition A, the updater will write the new image in partition B=
,
> >> and vice versa. Then after the reboot, the system will mount the new
> >> image on B.
> >>
> >
> > And what do you expect to happen wrt overlayfs when switching from
> > image A to B?
> >
> > What are the origin file handles recorded in overlayfs index from image=
 A
> > lower worth when the lower image is B?
> >
> > Is there any guarantee that file handles are relevant and point to the
> > same objects?
> >
> > The whole point of the overlayfs index feature is that overlayfs inodes
> > can have a unique id across copy-up.
> >
> > Please explain in more details exactly which overlayfs setup you are
> > trying to do with index feature.
> >
>
> The problem happens _before_ switching from A to B, it happens when
> trying to install the same image from A on B.
>
> During the image installation process, while running in A, the B image
> will be mounted more than once for some setup steps, and overlayfs is
> used for this. Because A have the same UUID, each time B is remouted
> will get a new UUID and then the installation scripts fails mounting the
> image.

Please describe the exact overlayfs setup and specifically,
is it multi lower or single lower layer setup?
What reason do you need the overlayfs index for?
Can you mount with index=3Doff which should relax the hard
requirement for match with the original lower layer uuid.

Thanks,
Amir.
