Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8949DAD24
	for <linux-unionfs@vger.kernel.org>; Sat, 24 Jan 2026 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769251532; cv=pass; b=Yt9z0l1SZww/EZNZj9QjC5I0bh7HvxKS9YG2uxQ+fEnsiZMOPPKpKNwGaT2uuRY5l+ydIx0dBONTbD2f9a8rop9mF+gT/0fqrdy/FkTEHzA+KgWikRD6Kk+bhK1k0gYYQjlp2j3vbX9tO/eVugy7keABmKffc7BfTowS7m61mc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769251532; c=relaxed/simple;
	bh=OhfWhlQZiS1Yq37GsKg1ZRvFgI+/q0guhtaSDhFcjg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VqwJXeAoBMiqPPHpTf3SX8P0R+LnaMhK/8ier+UehFAHCawiRcTvpoJKVaPGVu+CNz0kCP09oq8BYe/6bFSPz0qkNG3m8iQEauckslwUCeY0BxEWFDr5Ow2BVvbnAOJfRsIkU0TNLjQ3zKcNmEDj27zoq1NY9SBwnoZuHzvYtxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWrdm395; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWrdm395"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65801ce918eso5914003a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Jan 2026 02:45:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769251529; cv=none;
        d=google.com; s=arc-20240605;
        b=X+NT118SUYWR0SBLIOZQQ5XZ/driPTi78JYecyDrfBFq0LwgrkFMTqMKtZVQPqwtnp
         e3vykK0bCIF7JCFphUoB69qECgP/TBOlXBujqQTzlen8ZKnbcTM4073oRdHF4llmLBd8
         i94feBKoeMMQqBEqhqjaQ6WBypwZQJQgjeYdxxy9mUw+2kO9hkp/YJ1JCCAIw9qltYZd
         WDKBQO8P70lkveyrQPdVrcjVXdfH40CqHXzk1fw0AlcedVomvl3q707LlAivzKOurCbc
         wx11h4U9+pPnmLrT7lAeNjK/c19XGDMgWjB22dZzqjZNGE9txrBCiNUaG+DJVbW1aiyF
         vJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        fh=AiXL0DPEgFu+jrd3T8eVHTa/9/Ck1OfEQD9+5ECJsVE=;
        b=SGGNAfxsBnPCdLyA35AXLohHNaBPUOFqaMutU4PWX+MiFoCpSoxw4YRznkoQhf283/
         t4bwGDr//xpAhpguatR4Y2YyowXpxmX5Kyfug9UnJZ1u28i1jnq6UvCRlldjxY1yEHsI
         J2t5ctmF4z1X3jRIL4e3Cfd1+huqi1rZC3QiybNaGrYWSshI92MKKoiOxyR7cr6C2vS1
         JJwLfl9tBrQ4VqVs7DlHflgIUMTcL1DJaLdKAwG5CJhsHDKOmpV1cN1h+VBNVh+3Vw53
         Q7AgmZOY7urB9I/9Ixv3vI59ty5T1G9Nkvx9Ttabzvhn1Iv/9tLNwUjpj8Py/mDyaUUW
         klHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769251529; x=1769856329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        b=nWrdm395wUmY0BCaISWaPOutLg163MXaaFaptr3TTl4rfWl7AxdcgS6OuDLbYYEpaz
         wME6dE/pV4njENzX/dnctf1XEEQ37vKc7YP2fi/sWsKFP+qDie/YBSevOnzomRoJtiYo
         KMqzTpsJ+MwgRfGOu231yJ8/8kW47AMeWL50DlUX42blTBQKPcLC4C0MmTkdbDquDbra
         aGjiNQRHD9Am8aaaPhEa0sTUxxFWuByY0Y9yX5e9Avzpr8Y2dA3dbTopa12UxBbIXfwl
         mnW4sFPT0BasxFjWJrHNA5XOdlSRWKTj9C+w4Ku3fYVpEGO2k7fWwPo1tQsGP0cKx0hy
         T/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769251529; x=1769856329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        b=j4khcP3mrgm9szI/NGL62beLikQZgjm8/93Q6sCSaMNvMl486vsP788WQhkzvQ5/Eu
         b25YWmmt+8uTtCE5JciXq+VmMXXpy3OVT2utd4zWR14hbXrXMQFPK0V5s47ppXg+4Uit
         DldeAV5OppUFVifEczg/Y07m5qrJXH8Ky3459XOQHV8O4WTCcxWTMeEHChcH0wmALMH1
         b4w1AwxRL/NW/x+kdI9P2Gmj7Aspz0XPL1cW/VJBIlqrbqld5tsyJv8fmTa3dzkKSJ9+
         ufIbcLMsXXBDibBIxTwFKkI3X9kVt2KOgzPRtj/sE7Z89t0rKdFg3fmHXwhV9Pk86sQA
         br6g==
X-Forwarded-Encrypted: i=1; AJvYcCUJ8b13i5k8E6UOhb2bTvg+T0IIotigOt7iKuk81rZhxY5Wuuc0gDkEwRWYx/JWga+MEsjzFrOcj0jALEfI@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJ6lS5qOSddbTxRdVzxmZMq25430QyrpPh/vf4s5bE02Gdmc0
	/yaRxajZsd4yAOF9XoL2TcrOiDWHDC6WbhKECHymPT9jim2ulqTbcMMsg8Z3jGr9DzGnX6T60qm
	9116hXAHOUrqafgGLto4ALJg99WrAc6c=
X-Gm-Gg: AZuq6aL9tpHRM+wLRuxqp7pEDUU8DRD1gqQIItiSOvRTdN5mT7AEgiEOqVhiWI9RuiY
	fVOVl2xO5qNDzCqJTvDqLyXDerS7yVNKVQ8O3drZzXO3s+s1Q2T8Os0AHnM5wpOqD68BSf5lmYO
	hs4D3JyRLV6EiAbJGffCs1IMP4s8fNGBPNVuOWB7hTAucI8FR3dYc4LbKwxd511jzGTgMszNj70
	n60YjCt8O/4mayjwpLHewxZC6EvtCpIC/0Yx+mdyUtNO81B4YpY5J4zVhSsBX2MiXouwVFqhOWf
	t4JAuGVR7GJwhlsseaSLiaIvlqSCIAxuju4Zi34=
X-Received: by 2002:a17:907:1c0a:b0:b87:173f:630 with SMTP id
 a640c23a62f3a-b885ae61dc2mr478554866b.40.1769251528580; Sat, 24 Jan 2026
 02:45:28 -0800 (PST)
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
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
 <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
 <ee38734b-c4c3-4b96-8ff2-b4ce5730b57c@igalia.com> <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
In-Reply-To: <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Jan 2026 11:45:17 +0100
X-Gm-Features: AZwV_QilNv7skh3Dbv-Uyf4qbklEv15lpqvlCHXP7YddmY5hXQul6pw3DTKCtH8
Message-ID: <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
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

On Fri, Jan 23, 2026 at 9:08=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Em 23/01/2026 10:24, Andr=C3=A9 Almeida escreveu:
> >
> > Em 22/01/2026 17:07, Amir Goldstein escreveu:
> >> On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gmail=
.com>
> >> wrote:
> >>>
> >>> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida
> >>> <andrealmeid@igalia.com> wrote:
> >>>>
> >> ...
> >>>> Actually they are not in the same fs, upper and lower are coming fro=
m
> >>>> different fs', so when trying to mount I get the fallback to
> >>>> `uuid=3Dnull`. A quick hack circumventing this check makes the mount
> >>>> work.
> >>>>
> >>>> If you think this is the best way to solve this issue (rather than
> >>>> following the VFS helper path for instance),
> >>>
> >>> That's up to you if you want to solve the "all lower layers on same f=
s"
> >>> or want to also allow lower layers on different fs.
> >>> The former could be solved by relaxing the ovl rules.
> >>>
> >>>> please let me know how can
> >>>> I safely lift this restriction, like maybe adding a new flag for thi=
s?
> >>>
> >>> I think the attached patch should work for you and should not
> >>> break anything.
> >>>
> >>> It's only sanity tested and will need to write tests to verify it.
> >>>
> >>
> >> Andre,
> >>
> >> I tested the patch and it looks good on my side.
> >> If you want me to queue this patch for 7.0,
> >> please let me know if it addresses your use case.
> >>
> >
> > Hi Amir,
> >
> > I'm still testing it to make sure it works my case, I will return to yo=
u
> > ASAP. Thanks for the help!
> >
>
> So, your patch wasn't initially working in my setup here, and after some
> debugging it turns out that on ovl_verify_fh() *fh would have a NULL
> UUID, but *ofh would have a valid UUID, so the compare would then fail.
>
> Adding this line at ovl_get_fh() fixed the issue for me and made the
> patch work as I was expecting:
>
> +       if (!ovl_origin_uuid(ofs))
> +               fh->fb.uuid =3D uuid_null;
> +
>          return fh;
>
> Please let me know if that makes sense to you.

It does not make sense to me.
I think you may be using the uuid=3Doff feature in the wrong way.
What you did was to change the stored UUID, but this NOT the
purpose of uuid=3Doff.

The purpose of uuid=3Doff is NOT to allow mounting an overlayfs
that was previously using a different lower UUID.
The purpose is to mount overlayfs the from the FIRST time with
uuid=3Doff so that ovl_verify_origin_fh() gets null uuid from the
first call that sets the ORIGIN xattr.

IOW, if user want to be able to change underlying later UUID
user needs to declare from the first overlayfs mount that this
is expected to happen, otherwise, overlayfs will assume that
an unintentional wrong configuration was used.

I updated the documentation to try to explain this better:

Is my understanding of the problems you had correct?
Is my solution understood and applicable to your use case?

Thanks,
Amir.

diff --git a/Documentation/filesystems/overlayfs.rst
b/Documentation/filesystems/overlayfs.rst
index ab989807a2cb6..af5a69f87da42 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -753,9 +753,9 @@ Note: the mount options index=3Doff,nfs_export=3Don
are conflicting for a
 read-write mount and will result in an error.

 Note: the mount option uuid=3Doff can be used to replace UUID of the under=
lying
-filesystem in file handles with null, and effectively disable UUID checks.=
 This
+filesystem in file handles with null, in order to relax the UUID checks. T=
his
 can be useful in case the underlying disk is copied and the UUID of this c=
opy
-is changed. This is only applicable if all lower/upper/work directories ar=
e on
+is changed. This is only applicable if all lower directories are on
 the same filesystem, otherwise it will fallback to normal behaviour.


@@ -769,7 +769,7 @@ controlled by the "uuid" mount option, which
supports these values:
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
 - "off":
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
-    UUID of underlying layers is ignored.
+    UUID of underlying layers is ignored and null used instead.
 - "on":
     UUID of overlayfs is generated and used to report a unique fsid.
     UUID is stored in xattr "trusted.overlay.uuid", making overlayfs fsid
