Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720626A08F
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Jan 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583198; cv=pass; b=ILsfjZFplkLeHiSWGBqc5y19bFp3kruSObJYEcACq8Jdamr7eRWoVmrxHR0gQduR9ZjQfY7d0xMFr6pF0IWSoAs4EsZUHyelGDjz7fag+L4ftBtqFf0SimZHedPeQWETW5kCXEXhZokmCJ42UnOfUNe9HOpZltz1fkM12Q+TNTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583198; c=relaxed/simple;
	bh=AutWS+ChfvnwZhvgwiJu9L8XUNWLOmuOdlQ8JOwu3aI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILlImBmfa2NDh2I51ZiW+1E8RHhr94SX9YpCxIJtu3JFI6Dys08vtTZcPNs12dVXIUdOD92u0W2I7mjSES+z2AY9CivlnCW81Aanba6XzXcIP5+3t9P9Qwo54Kzwr/AGkuqSJJjTSX705VmxQBvGBYPIxZMPYxyY6rhMYWVRQlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IhMSKtKa; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IhMSKtKa"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b872f1c31f1so307425966b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jan 2026 09:06:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768583195; cv=none;
        d=google.com; s=arc-20240605;
        b=GGqVI9S8D5KBbhbFQhbJYylw4kp/dRxf9aV7tPEcF5cvIpZQ1YM5kZP0Ow4stkxXWg
         VxhOrYNX4PzGofMQOGlfCk8Xe7ZJkDl/qwHHKHpwa7Kx97zwvBcdQs9nqzZiSw8I0Xdu
         l6UwLJba+sFw/PUecOxAtRU732OME5f3D+N9fVFyKQ3IB/6eCUQ8soz5XKGsEZ6NZW1K
         lCriaWQQQJp4QGyn7JdnUhK9z9erdPDgi/jjsTpOkMXFFUFf5RNgIsUSM33stmxl4os+
         bHWdiPvhH7qFE8aoQdJ0JCk8ToY87gINWEopi0uxtGcT/PgENtaog2wRIK+WtDFsZFE0
         ustg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XItb6VFbJFsznrM8Z1kGxSYoWMyWGsT3kv3uyFtUZ1Y=;
        fh=O/DJA4OF2arJKRQfC64bAYyETrtQpKnLyOV4ierT45U=;
        b=GcVmmvWZ7B6Kv8HrMK0ZTS7ss7gJrInx+YsK/tzMuGv5nkU1QzjvBxnS6hgG3qy+8f
         ysNmOTO9/tqWa63fTb/ylp4rLAb5wKjxS2Bgfh7lCY7aaOcahgu9CCazNCwoVJAFDUF9
         LycaQIEqYE8q6Fs4lJS2BhTNc3uAgDzYYLQWtOTs3KJRNHzjN2Cmu26ns5Ugysuuqh+3
         /4JO4zJsKoZjFQbr0y+L1Qgvz5kNyXyLmBkSCmjIpAnPiwOqh8F+yRi9pf7Hy7O/Ba+U
         XUmTuIkTPo5dp4/N0EB0fpg6vY5640kiXwmmtfCLFZ6Vi7ghmc9bSm4spR4577UQmn0h
         CEmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768583195; x=1769187995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XItb6VFbJFsznrM8Z1kGxSYoWMyWGsT3kv3uyFtUZ1Y=;
        b=IhMSKtKaInAjrrAr5VM6ei28YAbFYHSe3d3k41G1Ruwu2yhJloJySjlPBPAMQDKx3p
         EQ5CmjuREI5k/GUIw8K+fzaDX9QShVwycft/lqao/M18lDOhI0NJBa0RpkhiJ2pvt7K8
         D/ERhK4E2MY3mZzLCc03/aTWKZ90WnhUj9Go5z7ivGLuW7wYtfn0Qeg0hzbW6hbNftgG
         df8KlNPgCvp5qQHH6KttDWpApVbKvO0SH/1KLecIF0gfrc3pqoXs4rRyTgF42lJHW/yK
         K2RoHQAms4bU8iXM3yKxjbrKs7rpkByiFEec9h2rVa66JWgAj7HIajNmoheECxLUGlH5
         rwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768583195; x=1769187995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XItb6VFbJFsznrM8Z1kGxSYoWMyWGsT3kv3uyFtUZ1Y=;
        b=bGfyWZ5RocLXIq+sQeIT1XzWvHu1BRx8kuxBlZx2tOntc+Y1y9hssCh6kVJMrrZTEw
         owmoJKA/PqKNCJmas5AElrVzVu1Hrvh0BMlirhsd+mDv+0dlcoXIBA8DdGdYckvEo7J7
         naX/IvEhVVCNlcskKVU8dQSSqgeh/95K0NWRylI6YEmNY5Fw5QbZwTSf++gHKfOI4fQc
         KwZ7AgSMDMD+bwDxBa9kCe1306lStwh7tRNqBoJPdbkIC5Ew7IKs9z1iviGR9BaR7ozp
         oeTq8hSo6ho5s5Z2DYZtBoRxN8CtJLQmokRFM1EHljbVlnD2d3kWqHg4E6y0BAWEYbAe
         YdPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMNaqF0XZSm6gsTm1HFicyO93IBsf7rhjlGLrxBXj4EiOa2hlBlQ7S3IkgbTP1gtAiAWLYy+PUOuTu7Cx2@vger.kernel.org
X-Gm-Message-State: AOJu0Yz72HZRaXjmooW+1pWMne/uLcye/lhK7bogh4ZbWOFw2Ta4GOio
	C71wfEiQltbGimGG52Ru1PQPHBA6wdcl1dK2Ke+VhOoAd6mcS2lh7Jb4b4WrbEKaqyN6WqAxIPf
	z7w1pSqqvFe0WzT0ifW+YPWlHtgYDRYE=
X-Gm-Gg: AY/fxX7izxgarrJpoTCr7ANEXu2viQIt6bYuSq/OJftZwWK9LHwaO0gNVgIywJoDqNr
	GVE5ii3kUbf+ZPyIdjhC/L1OdvI05WykYAabQ6rvBKQaS4ovkY5CyrdgTRrLYSDTGAppYcjQI05
	CyKyXVdpybEOU4DRFMviCGVytP2IyiCpshJVlnn2bsogmuILA1HoYmgoVusozzwkshONSblM6rs
	kZ1CrUcEFbLAMbtb8CHrnOOFItQaS9uSYNrNUhIQ+hyaovI9vzFv5iQmeXhckMfI90EX9fj1SpO
	53gplghaijppwMjfeHNbVei7Jgs4LrJ2BKGdcBK3
X-Received: by 2002:a17:907:8692:b0:b87:63a8:8849 with SMTP id
 a640c23a62f3a-b8793035646mr264423966b.46.1768583194354; Fri, 16 Jan 2026
 09:06:34 -0800 (PST)
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
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com>
In-Reply-To: <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Jan 2026 18:06:22 +0100
X-Gm-Features: AZwV_QiycpCXWte0-e38-ESYar7TKmRhifBZp2CxcdBlO9fcQ_xptdhi8v4o5sg
Message-ID: <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
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
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026 at 2:28=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> [+CC SteamOS developers]
>
> Em 16/01/2026 06:55, Amir Goldstein escreveu:
> > On Thu, Jan 15, 2026 at 7:55=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid=
@igalia.com> wrote:
> >>
> >> Em 15/01/2026 13:07, Amir Goldstein escreveu:
> >>> On Thu, Jan 15, 2026 at 4:42=E2=80=AFPM Andr=C3=A9 Almeida <andrealme=
id@igalia.com> wrote:
> >>>>
> >>>> Em 15/01/2026 04:23, Christoph Hellwig escreveu:
> >>>>
> >>>> [...]
> >>>>
> >>>>>
> >>>>> I still wonder what the use case is here.  Looking at Andr=C3=A9's =
original
> >>>>> mail it states:
> >>>>>
> >>>>> "However, btrfs mounts may have volatiles UUIDs. When mounting the =
exact same
> >>>>> disk image with btrfs, a random UUID is assigned for the following =
disks each
> >>>>> time they are mounted, stored at temp_fsid and used across the kern=
el as the
> >>>>> disk UUID. `btrfs filesystem show` presents that. Calling statfs() =
however
> >>>>> shows the original (and duplicated) UUID for all disks."
> >>>>>
> >>>>> and this doesn't even talk about multiple mounts, but looking at
> >>>>> device_list_add it seems to only set the temp_fsid flag when set
> >>>>> same_fsid_diff_dev is set by find_fsid_by_device, which isn't docum=
ented
> >>>>> well, but does indeed seem to be done transparently when two file s=
ystems
> >>>>> with the same fsid are mounted.
> >>>>>
> >>>>> So Andr=C3=A9, can you confirm this what you're worried about?  And=
 btrfs
> >>>>> developers, I think the main problem is indeed that btrfs simply al=
lows
> >>>>> mounting the same fsid twice.  Which is really fatal for anything u=
sing
> >>>>> the fsid/uuid, such NFS exports, mount by fs uuid or any sb->s_uuid=
 user.
> >>>>>
> >>>>
> >>>> Yes, I'm would like to be able to mount two cloned btrfs images and =
to
> >>>> use overlayfs with them. This is useful for SteamOS A/B partition sc=
heme.
> >>>>
> >>>>>> If so, I think it's time to revert the behavior before it's too la=
te.
> >>>>>> Currently the main usage of such duplicated fsids is for Steam dec=
k to
> >>>>>> maintain A/B partitions, I think they can accept a new compat_ro f=
lag for
> >>>>>> that.
> >>>>>
> >>>>> What's an A/B partition?  And how are these safely used at the same=
 time?
> >>>>>
> >>>>
> >>>> The Steam Deck have two main partitions to install SteamOS updates
> >>>> atomically. When you want to update the device, assuming that you ar=
e
> >>>> using partition A, the updater will write the new image in partition=
 B,
> >>>> and vice versa. Then after the reboot, the system will mount the new
> >>>> image on B.
> >>>>
> >>>
> >>> And what do you expect to happen wrt overlayfs when switching from
> >>> image A to B?
> >>>
> >>> What are the origin file handles recorded in overlayfs index from ima=
ge A
> >>> lower worth when the lower image is B?
> >>>
> >>> Is there any guarantee that file handles are relevant and point to th=
e
> >>> same objects?
> >>>
> >>> The whole point of the overlayfs index feature is that overlayfs inod=
es
> >>> can have a unique id across copy-up.
> >>>
> >>> Please explain in more details exactly which overlayfs setup you are
> >>> trying to do with index feature.
> >>>
> >>
> >> The problem happens _before_ switching from A to B, it happens when
> >> trying to install the same image from A on B.
> >>
> >> During the image installation process, while running in A, the B image
> >> will be mounted more than once for some setup steps, and overlayfs is
> >> used for this. Because A have the same UUID, each time B is remouted
> >> will get a new UUID and then the installation scripts fails mounting t=
he
> >> image.
> >
> > Please describe the exact overlayfs setup and specifically,
> > is it multi lower or single lower layer setup?
> > What reason do you need the overlayfs index for?
> > Can you mount with index=3Doff which should relax the hard
> > requirement for match with the original lower layer uuid.
> >
>
> The setup has a single lower layer. This is how the mount command looks
> like:
>
> mount -t overlay -o
> "lowerdir=3D${DEV_DIR}/etc,upperdir=3D${DEV_DIR}/var/lib/overlays/etc/upp=
er,workdir=3D${DEV_DIR}/var/lib/overlays/etc/work"
> none "${DEV_DIR}/etc"
>
> They would rather not disable index, to avoid mounting the wrong layers
> and to avoid corner cases with hardlinks.

IIUC you have all the layers on the same fs ($DEV_DIR)?

See mount option uuid=3Doff, created for this exact use case:

Documentation/filesystems/overlayfs.rst:
Note: the mount option uuid=3Doff can be used to replace UUID of the underl=
ying
filesystem in file handles with null, and effectively disable UUID checks. =
This
can be useful in case the underlying disk is copied and the UUID of this co=
py
is changed. This is only applicable if all lower/upper/work directories are=
 on
the same filesystem, otherwise it will fallback to normal behaviour.

commit 5830fb6b54f7167cc7c9d43612eb01c24312c7ca
Author: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Date:   Tue Oct 13 17:59:54 2020 +0300

    ovl: introduce new "uuid=3Doff" option for inodes index feature

    This replaces uuid with null in overlayfs file handles and thus relaxes
    uuid checks for overlay index feature. It is only possible in case ther=
e is
    only one filesystem for all the work/upper/lower directories and bare f=
ile
    handles from this backing filesystem are unique. In other case when we =
have
    multiple filesystems lets just fallback to "uuid=3Don" which is and
    equivalent of how it worked before with all uuid checks.

    This is needed when overlayfs is/was mounted in a container with index
    enabled ...

    If you just change the uuid of the backing filesystem, overlay is not
    mounting any more. In Virtuozzo we copy container disks (ploops) when
    create the copy of container and we require fs uuid to be unique for a =
new
    container.

TBH, I am trying to remember why we require upper/work to be on the
same fs as lower for uuid=3Doff,index=3Don and I can't remember.
If this is important I can look into it.

Thanks,
Amir.
