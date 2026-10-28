Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793201780;
	b=ZSqdHvuv40OfMznO++gCLlCD6JLCY3Mqig31aYhUk/dY3JpJFTUoa9oUaxoEJ6QjIEoR
	 Fr62caLfGpIPdGTHzgH3G/b2WOnFCBTtZb6smWAcV2vPntC8MS4tPRXTxkW6Q/SOdskA8
	 cbVzSfRlF5yyHPuQvFAtsjt4NuZsFm3+QK+EQUQPRUEJr6GEtuov/7B7Tnd4G/PZtajIk
	 WgAajboGKXAkdxWOcAafw/Z3/EEYNIYTjU2IHfSL852MulxwD1ZvfxdmYOHdlurlMj3iB
	 EtNecVJYrWrcU6Aq+KdwN4IlsXiwW+9EnMjiEtrqkNEPfaokhjYqkjjdsX+xzC324XA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
	b=R6gln59FEcwATlQ2qi4l1xtKbYkiBFXRtzsrtFYF790cUjvBfFTkTxqzAol+wCwijm+D
	 hBa9c7WG2ZruEpczY/2OBruQIZC/KXLbhPpH/JHtwcvcOl2/0bNd3sSLs7WCjvP+B7i+N
	 R9Dbtr7GIKgMsMcSB/GylYVeckfUsIHbFfjMgEqi0y3Z7gLVW1WKyD3yjAnuxIWRGsWXu
	 BKBGg3o/qSOmZJw4lj3t6+fQH38RyAlxQZxDWilvSHD27dpNa2HQR/ThZdwWNncdf9pCs
	 GH5q027ycGKW2KnYr3tL3OgWqV95ZrjV2dZV0hySpgsXBJiVnXtSCRSYCB7kQf7YpiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="o8+eS/kO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD75960A2621
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 15:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD75960A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o8+eS/kO
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso3714869a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 08:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201778; cv=none;
        d=google.com; s=arc-20260327;
        b=TRpXmhmymzKfv9DvEPhLmmVfRwHGKG89U8FRjcCQ5sXp5VV6WeU9/zC0/zjaPUioac
         9fpeM2g09bxnoViT8gWpl6+Qd7R1TMlySxEo8+OYg9Ty7Yv5s2u2Q83gbP1rpvghfYXf
         9kuPL1bQNUom2v92Ev7UJsNayCum75l3HLbL2R9K7YXgJyA69zXUKdlDNKNUikQFOUGX
         wle4wEB9rAns6FwZGhzJmphHtz8PZSch7cpARtkgZedigmieX28jJvu3SU7wRRVHV7sd
         IuLK7d8/4YPwZcLloyS/3AK2plCug1AF0RCBP41Sh5r8RoQWYIS02AdX8W84etQIwoXD
         EzwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        fh=s9nw71s7VbfUmDME0Rq/j1ljpwMnENVE4PkIpsoDqYo=;
        b=EAijb+tOE6FZ2m7VbW6Co1AySPnbdBmpznkpHLS9deXDuoPOPpOKyhbyRha7eX9ZpB
         agat+7Ztd51dpg1+lcr9c6sqjtDZkQarsPFrIXhMqPCw+lK5e1ltCmXcIM4duJyLDhNg
         dYaMwKatzPRP7+v4YoIc1aZ2Ofs9GJbhpZUn8JL5uAzbuLAC7Lv5wvOycx133t9TGLt2
         uUBQICRwm0jXtOJLgHFAhHP65GX/5yWBSZfbqMZC//pUeJSBcdiCGiiukskmnUYGulnO
         8Rk6ZShPrtY9ttoxyur1cR86UHEUfp+qqc3AwoamzcVrcn2B5OMgKa6w6JKxR5fRD/Bk
         YWEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201778; x=1793806578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=o8+eS/kOJnmSQQuDmyzKcnpM8XIf62WHDcQTpfgGgAc33ST6Cpvb/Avm5gCEO3G83f
         mwT5WJaRXBMVxl81EO5AaJjNxHST8plT8azYXYCCF/zkFLzRRxL39DAnbyDEtc0izQ7z
         BXoAb+hBgpOG2MczfmPvBVDGk/iwK7R5wDwXpDgw00NJCrhcdpnLJlcQCfyX7fUAE/q3
         TuCIcIAJMA+UYbeKn4XOSAztm+6f2MAyPPJZPpKrZOIFxUTkZmyPclmqG21F1aEzhplB
         iTR/S6KCchmPfCqzmnzIC7zf+BT3HW7rmx33Rm1wtRiZPxIFwLBfca6G1MEP1JTTmXMW
         ehHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201778; x=1793806578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=areyGkdmwjTKV6cCCxWxpPSl6DOlJ2ArQBhBni/MeVRmmraNVIKCv+sG+wFcjLv6Z8
         +kPMOWbGCAYfqQzeskRJchVer8EPhJ0VtCHLDT7uwYTFErnv8dtakqOI5w5iF9IanwM0
         Uz3wan5igraZXXpupfHXYy9p99AkFSa9Im97Xhh5bPGRDFDVrrKOTWPV7Yl2wNvBaRYY
         j3yPffYN2V08BbreapNC43rBqqejiS3IK6TYVgQArlNbYPlCooJ+IjDLk3RKYlodMha2
         TarQEQxAkWC0sK+DVLS/JpcIFaWabgZfDGCPDMS6olklO9l1Qt3hYEvf0Ldz38vmpGfo
         P2hw==
X-Forwarded-Encrypted: i=1; AKwUvByJmSa6MxXzPA9xCccfYSCQv0tu22uyKsbKbGcTnaweQT5MbZ4e8WrNstyQhbN1Yh5Xfg1bWCpSMjis2Ym8@vger.kernel.org
X-Gm-Message-State: AFq9FYK1s7A1yOvqM1cL8VM8twkkbHOsDbORlAeHBILosHd0IvNAcO5Y
	W2xCIn3dxdbw7BQsvY7OwllR8tBkBTrkxPzfjjbedxwX+couzECR4DiMYVv5cWvJt2nK2xjCbWD
	sMgGqCV892TOABvKlzeAYM+meoUTanls=
X-Gm-Gg: AYBFou3LGWuj7WK22/OOWxkI5qBMWiLU2zLdjbf0mkU4hWdI6y8L0JvNUGxNdhIJ96a
	fVvZT4bBXprinnJsEOQOe7Dq+SUy1bbJ0Fh6w/AS36QaFosOvXBcvr1/9l8GWvVbSadVZlCO/tJ
	Xj9x9TqE2mwi4jNOg/IDUHLHCXqLXetf/aWtef7Imp4tvIOI0/lrturA0agolnHS6O8m6dmAuav
	IMNacZ+0SHlPGZaXMPd+WyN3BCYbLVRXKBGwaGoT/t73lS6vG4dZDvUjBhIrVoALL7UcpjqCfP3
	pgbZkX7uHUe9bXxBN7kBhHpyHH1okLvOGvsbJzS2RpKtcQoYsYI72e/sjmZYO1Q92RgNj4vBXvq
	r+7E1sXKUmEhnCqUfAwaeis4z4Aafx95DLqYJ39ykVaOUV00hXwa/SwdGn0aHu7JS7UBpXQ==
X-Received: by 2002:aa7:d955:0:b0:6b3:b0b2:6e7 with SMTP id
 4fb4d7f45d1cf-6b47bcde687mr3518808a12.18.1793201777944; Wed, 28 Oct 2026
 08:36:17 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 17:36:06 +0200
X-Gm-Features: AclHuK-uy9OcEc2oh0_9o59ea-Px6xRmZClAxF9aj0taY8198qZo83-6yRUk1Js
Message-ID: <CAOQ4uxjNWagHSXM0q+3q-SwX1RRun746iSsfyoR-4fLjcqH16A@mail.gmail.com>
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, 
	Carlos Maiolino <cem@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:09=E2=80=AFPM Josef Bacik <josef@toxicpanda.com>=
 wrote:
>
> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.  Whether the metadata does depends on
> the filesystem.  ext2 copies an inode to its buffer in ->write_inode() an=
d
> nowhere else.  A filesystem which logs its metadata has recorded the
> change when it was made, and ->sync_fs() commits the log.
>
> overlayfs wants to sync what was changed through one overlay instead of
> the whole upper filesystem.  It knows which inodes it wrote data to.  It
> has a much harder time with all the inodes which the upper filesystem
> dirtied on its behalf, many of which it has no inode of its own for:
> whiteouts, index entries, work directories, the parents of all of them.
> With a filesystem which logs its metadata it doesn't have to know.
>
> Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() wit=
h
> wait set makes every change of metadata durable which was made before the
> call, whether ->write_inode() was called for the inode or not.  Timestamp=
s
> which lazytime holds back are not covered by that.  As an upper filesyste=
m
> of overlayfs it then gets ->sync_fs() instead of sync_filesystem().
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  include/linux/fs/super_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index 72f4288e16c5..370b0d27815b 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP   0x00002000      /* No idmapped mounts on this sup=
erblock */
>  #define SB_I_ALLOW_HSM 0x00004000      /* Allow HSM events on this super=
block */
>  #define SB_I_NO_DATA_INTEGRITY 0x00008000 /* fs cannot guarantee data pe=
rsistence on sync */
> +#define SB_I_OVL_USE_SYNC_FS   0x00010000 /* overlayfs: ->sync_fs() comm=
its all metadata */
>


I have some reservations about the flag name (how could I not).
Not easy, but can we try the flag to describe the contract?

I am interested to know if the same flag or maybe even a more
strict contract which is fulfilled by ext4/xfs/btrfs could be
used to help determine ovl_should_sync_metadata() -

In commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
we added fsync on parent directories and metadata after copy up
to fix correctness on ubifs.

In commit 1f6ee9be92f8d ("ovl: make fsync after metadata copy-up
opt-in mount option") fsync=3Dstrict was created for opting-in to fsync
parent dirs on copy up, after a report on regression over ext4 when
due to the unconditional metadata fsync.

I am wondering whether fsync=3Dauto could decide regarding fsync of
metadata on copy up depending on the flag, so metadata would be
fsynced on ubifs and not fsynced on ext4.

The problem is that your flag speaks of the metadata ordering contract
of sync_fs(sb) and my interest is the metadata ordering contract of
fsync(inode).

To be more specific, in this sequence:
mkdir t1
chmod 700 t1
mv t1 A
mkdir t2
chmod 700 t2
mv t2 A/B
touch t3
chmod 600 t3
sync -d t3
mv t3 A/B/foo

When A/B/foo is observed after a crash, in xfs I know that because
all metadata writes are serialized in the single transaction, the mode
of parents is correct.

Not sure about btrfs and ext4 fast commit.

If you think that the answer is that they provide the same guaranty
then if the flag could be named something like
SB_I_ORDERED_METADATA or something and
the contract is documented, then perhaps it also fits the
sync_fs case, because what you really want to know is that
sync_fs persistent the metadata that the inode depends on.

Am I talking nonsense?

Thanks,
Amir.
