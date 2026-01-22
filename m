Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3C3904FE
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Jan 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769112468; cv=pass; b=jKBRJk+NAjIStILOecZte451FarYputCHgSpA5iNh0YKncFSvbtC4Up841U9h2EOij3QKG39bKA14CR8bOPLdigei4puUMJsih5Hb1JyxlO40o6HTgEA/RqG8eXgGK6RicaUJTA1Fjfk5ct9PhEGlFD2tDr1zN63jetXdKzAv+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769112468; c=relaxed/simple;
	bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ts2hk32KWSjlRduUHczQVQxhxlq9Rz3/LEqEOIR+DXQrLAZmiCS8/9xcpLGOz2a9otGCh95aWkEpkWO3L9XkC67qPp4Okup+AmJlLlQbETYjSY+tGkuSFfTGBXZqUK9OPv/FXYJdYi8KTMUtgVxKjaJxqShv9Dv/sV+4+mWI1UI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/lWqrLz; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/lWqrLz"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso2402637a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jan 2026 12:07:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769112459; cv=none;
        d=google.com; s=arc-20240605;
        b=llhRethV/9D2f212KO61WzdjBwn51ZiZ4flELgTN+FRln74UqOpWodJ0jrt3ZyNmJA
         P6vqnbXFD+tJNpzyjX0+8droQPVPliDGHATip+mpEPRzd3Tt473XooVpkeANES+nsGV5
         cJABIJHgY/EA4rYm3YCmQo3cqKOcDGPYO5+rXLHC0pyec6ODCnR8eTAqLo7Ev6GT06fc
         QTWkURCJU+LWVs7XMBApt1CgNJdgl9irvJK933KasS6qjQLO7SKNGNyUZogDal1jhI9i
         UW4tEDwTqAqdomho4nKT9HHLv6Akh/s3F4Pm7pJgnRu2CxHtTdpLR6hi9KSgb8zcypzo
         8LkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        fh=/gf7D0fFhBz2sxEk+w0C9sa7XAeKVp/sdSGGeYpp3NI=;
        b=FseFO6jDpmG6WHB+AvuzXw3SOcxYfGjhecKXkge3C+m2jaMGEkuSipPrKMeKgg9fqu
         rtigx6quuawYL4XBypKZbRAxktct+sPN/WWH2XVHy6uEs59cmZxUabnK9I0wj1lNPyPB
         4zmWmm9Za2lSCVpRep6uwQsLN+lV6jtTM/7siGi+ukwVhdgTZMR4DaMA9ojGMAYOSXU9
         MwDOfZJ/al/o6AEeE6AH+ZFbpXhYe0dC06dqtztJn1pBIb0dB35exuR84Hp6PdhhQMPq
         46y2jGFHq5/kKK6u7bCsoyM753gnQhqBFp2WivqHmdH+ozTFNBMue030P8klh7jPfq4y
         25Wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769112459; x=1769717259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        b=X/lWqrLz2bQ6qvlxMp7/4e7A3KNMkcvHPGvJrXvIoIFpAaXIC/J52gb0mTswrvGFCP
         qSSVd1czapsgBn9o4IwsRwvrzkDyZFQx/Q7wv1QR4ekmsTMySm+kz1F5NgHYxohKdeQW
         9UBy+879Kpi1tgCxNhjuYt8DS45VfiBkOyHJO/2HCOK97WnN26k3ENKaWBrgHO+JG8UL
         BEq6qWIJt7oQcNqg684IBIHDoze+DmC0pRYl6PWRXWVulbGGtM+GXeZOX3icPwGLoZvy
         F8yBwJU6ABDv/T7C8paHIdvH8dD98D8xBTj2IE6kxogY0Puri6AgRf99EEFaozcudOgy
         Dzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769112459; x=1769717259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        b=azqIJQJAU6FeRq2wV40CZ5quHjyGG1Qn2/ud0riqsPOusf94OrSHKfQZmvYj0wzdbQ
         Qufisz/iEIn8daf/sQHy2qPlC7yTnv8pbXFYqTNyAYtyyb0cU8f5luf9w1eJDXQ8vuLZ
         AWF+I3ai4CBRgG4oWJjWGYcgS3OM76inWYd5BeyL+64tmV6nyi1SdmETovDwKVUqOSym
         4JtLDTVUI3Z1e69dD1dvJgx70yiioH5J5tbX2nzS7dQ7PysLaYbE7e4vNg1swQBTxyoo
         7jit4R54Y7+Gq5lsseqVkjFGBH70xVxUkg/yw09zwFyeJcFtADpECItma5xXkEOh82bZ
         VpaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpmJLS9hOSSb6Wa/1RuZTB6nl3xQcSY32Ps4C52QYHfmYV2rNg+w3Pbqz8klD1fQ6Cp9xzyqPWTnTpZeOp@vger.kernel.org
X-Gm-Message-State: AOJu0YxrMvVZrgvqURstD3hgE5rC3hAwCe4+xPDniX7AVbynT++SQ1Iq
	1DxOTZ1r1F14fspxFV8NivA66/IAus4k44xNBngXJ2/ajcB5GqM5KCRAHuHA9J7wuZRIZkF9xAc
	m0h29mFwv3LDn+Ojp/7U1xAAaAn75Hvc=
X-Gm-Gg: AZuq6aIL6OQPOb+naLXwuEr1D9LpeNMFiGvY4931NNDDc3rPRdVDVVxCzG8QIWgJu6V
	/RX1OsDFBmNMywHrK356/Cs4VA+E4YD4XO6LYGG9GFpZl6Soo/eGQDiAyLfeEGFo9yOzB4iDz3Q
	ZSPx49HDTEjWhK4Nt5vWufIM4bdy+mxW6RPGZuQtKiXpL/9X1rasxHqi6YZOQJP/Pp99YHmT1EG
	8eGdDwRQ+XaOsg7OXkjpD8I7BkDDcKakhPbL5tOCeGAEpzDG/O2uMvEd/ppwIpDPvNWnvPUga12
	Sap6vASLf28X964PgUYLQ8l0W341ZuocFVbfPh1S
X-Received: by 2002:a17:907:70a:b0:b84:42e5:2b7e with SMTP id
 a640c23a62f3a-b885ae682a6mr30056466b.51.1769112458391; Thu, 22 Jan 2026
 12:07:38 -0800 (PST)
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
In-Reply-To: <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Jan 2026 21:07:27 +0100
X-Gm-Features: AZwV_Qj-Pre4XZbhvcFXr13YDWLuhkhhzBZFRQumTLtcoMVU1rOesRZLphknff4
Message-ID: <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
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

On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@i=
galia.com> wrote:
> >
...
> > Actually they are not in the same fs, upper and lower are coming from
> > different fs', so when trying to mount I get the fallback to
> > `uuid=3Dnull`. A quick hack circumventing this check makes the mount wo=
rk.
> >
> > If you think this is the best way to solve this issue (rather than
> > following the VFS helper path for instance),
>
> That's up to you if you want to solve the "all lower layers on same fs"
> or want to also allow lower layers on different fs.
> The former could be solved by relaxing the ovl rules.
>
> > please let me know how can
> > I safely lift this restriction, like maybe adding a new flag for this?
>
> I think the attached patch should work for you and should not
> break anything.
>
> It's only sanity tested and will need to write tests to verify it.
>

Andre,

I tested the patch and it looks good on my side.
If you want me to queue this patch for 7.0,
please let me know if it addresses your use case.

Thanks,
Amir.
