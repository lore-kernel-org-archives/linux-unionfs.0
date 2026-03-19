Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7933DC4DD
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773932052; cv=pass; b=qbH58JDBYzzys6udyy3IZJCwJZStvPcruRs/4lKPKR4EXvk627ICe2vxzP+wkUwfmA62HubqK6aqnxARt6ECtqYmwRA8H9pl6gsWzz9d3tfvspdBfntBsxDGtptV9vnRqGU6e1Tr7j7uEahNelqxlI0YIKQffnOjYUlmJnzjjEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773932052; c=relaxed/simple;
	bh=UmN42XIFxWPA+oc5RV+ztiTu/o/KFtkvvg5unw0jZ4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kqn6NEtnyrMVZyivFtz/2u5p1rmHzH8L3NF60MRJvcfcb/ceG4XYrO16lcuH0NcN1eK/8kCvJ3vJXDWrQ4y8oV3w8icm1d3LA/WSfuSNacZR9cu4ujX8ItzVmABJpD8vCqtwVm8S5GEi8kM25OLK1wL6zsz55rGvVZiGv2k+ToU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hXdDk7A7; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hXdDk7A7"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b982a80317fso30833366b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 07:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773932050; cv=none;
        d=google.com; s=arc-20240605;
        b=P5jxCN78Y8pXakfL7H7Z9/XgMCKX/x1OdnMO73TPdS5VdQF5ys4cWhg14wBWPI3yK0
         4zsloAthsOwp/DYCgk9CSynvImt87z3ID8ta+0J+RMFuxYi2w50W/WTnoLaGLpiks0VF
         qBBXn6nzDaHpRiLtSTY8synUERkzPv4o7QYamp3SDAXnYu0gh17gF+9UWLk1SsFbelKR
         1e2vHhV5XNnUpxuy7Fe6YSWBLVWHVecMi0mqqrW2blh64zzHMNwGhzDdDD0aOD0yeV9g
         uuhDNZfLywK74l2aBh28KK3+sEHM0bQUOW8cgy2HQcK/MxkwK0uY8ItZwY9cw/gSR/ml
         XUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jw0GH/4mNtxvnbd70gE+2uTwAn5ypE+g4jyg0EIdEpQ=;
        fh=rHQ3UeZoOdF6GkIAwfR0DFYM9tLOIxJapnUdDxnddg8=;
        b=PXB7MsuwX/b1tIVY4J9KkW8SG3mVoiVdPRC9uf9KwUPs5rwhIEM7IF1v7+rqrgMZ7G
         WwReIZCsTEbDKPiZ+KuENeYPSWpZdx+5N9GOzmqFNYCs3+WASS+mONCpI1PzpUgmt6ms
         BQTdUhPj9nKnui0FqHdw898AjIpMF8Mba4bdSDHvSfO0DHpxrU9sKn79Z5vooAEOEGIG
         NspTqHsdSRoqIHbbFoYzUN27w4N3w8BZLgnK0SI1/S5SiQBRKGayZ9LBQV2qLRXnbK3T
         Qsgu79syiIkDQPSPx4dctExo+M5Pi8GdGlx76BYbbO/OBaI0ZhZzE9mlbXmGi7xeSC4l
         /7gQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773932050; x=1774536850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jw0GH/4mNtxvnbd70gE+2uTwAn5ypE+g4jyg0EIdEpQ=;
        b=hXdDk7A7vGYw3Zx6tF71xgZ7WwjEnaSx5y641xv65jo7qeQ8m8GRnNgGYdbd7kyl6R
         jJrYRxgyKtVCKK4gWldoBp3Tvv5JIfA34Qk+AUM+Tc1yNVtKuQOzEjlcqKADPmBmdM8w
         Abw0s9L2n45ICgImp7PJzWtFr3S9gAQrMEjvGWASPn8mFsb6ObKzNoAMwTU0IXbMD2wE
         RqECz/OvszbdyuC1gWzGfiUkUSZgpXR6vJXzxNUgUd6dbCF/7aJ293WWUo3p4R/57EBl
         UZcoxF6Zh44ecjSgAzXPCdgTQ7czPzt94DSczCXot4iFxD9ZleUU1yD7bhYc660LKoOY
         FQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773932050; x=1774536850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jw0GH/4mNtxvnbd70gE+2uTwAn5ypE+g4jyg0EIdEpQ=;
        b=EnWMxhiLtNfWyrDzZOh/RvMsUTMKnweRfq8+YqIg5f2G3gkMR2OEPyN/IUgtptejzi
         feLinhUH0O/U2OvfzUq0rBw0l+AMW3JWndjBKIJ/S9Ua8aMmMxd2D0SfeSK8IT70Py47
         3bQEb5wQzRj92bQWn+7pDygchjZY7GkWH6qfaOZJfCeg21boGkpRLtR2COMjB+VQWxhe
         vngm0HEKoMk5oytDdezwAciBPzlnw88OhBKg/9oLxvwO6nHE0KQkTBHpclluBdJoFQdt
         LXGyIGmouxWJ4FCRY2xKq2PFWoJAIw6he1K9I8xq/XEdBuWVi3aJF/blGWejDCDSaTki
         dpmg==
X-Forwarded-Encrypted: i=1; AJvYcCVCo7DbJLi7jjvm0Djgo3X3ZEOb6OS5tmDyrVJ/x/xVZQBgQdIV/cthoQkEc2/H6GPrln+egHvvp8IAjv42@vger.kernel.org
X-Gm-Message-State: AOJu0YwLgHBhyf67dAIfJsgnpoGdpFPrE585S/SaytXp8wWujAbt82kV
	v1KQ8CbVT48kg34UtKMlOtEqtzr4cjB+N9V2waZaz88SJsTjKW4zPFqwNMAqSN9jd5aglOW5ZJ1
	bFkCz0RXqfmHXiPTKscO/EiBOwhn601pGpTc/hNg=
X-Gm-Gg: ATEYQzz8eVLegrm7RqONU+Y9OZlyg4NJXWYwGVMaGFEJqjeKKTKnzQIPhY3vq05DvnN
	+3i2dhSeqVBvq2oAv5lxnEkCcN6NWTl1TbP6MLz3f0wjpjlNeEHmU+eAn/ZIX6heypKQS6LSKEo
	gbrsry7pweCr0qG7/q5V/0CZCBck/MIdDbgg7e2JPxBdQlNciEk75CioxuMS3opDYScdiAYlCGz
	+GCgIVIWyA20s/kmmQSt7apKW4/PzfK/1iayC+qy94QWSMfJF6wcCMt+IH0alTZC48WweXPqKho
	xLinymKmxRn8GVxM6YNGz9D4MS0QyJQZWgYcNyLaw1q63pggalp8
X-Received: by 2002:a17:906:945:b0:b97:d76f:3790 with SMTP id
 a640c23a62f3a-b97f4948e4dmr422735566b.24.1773932049652; Thu, 19 Mar 2026
 07:54:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318131258.1457101-1-amir73il@gmail.com> <CAHC9VhTKvOzMS2ZyawE=qBN-EpyucfxvwcHZYjXF5zugRhE2rw@mail.gmail.com>
In-Reply-To: <CAHC9VhTKvOzMS2ZyawE=qBN-EpyucfxvwcHZYjXF5zugRhE2rw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Mar 2026 15:53:58 +0100
X-Gm-Features: AaiRm53ob940soSsJtP2tgmiMXVCsKvszmwMYDw08PfOi4CUawSVTSX4zhGKxzI
Message-ID: <CAOQ4uxj8SZqaFbrVifw0uw7skbUvJP1_nLWj4PYCeZuaLy5t_A@mail.gmail.com>
Subject: Re: [PATCH v6] backing_file: store user_path_file
To: Paul Moore <paul@paul-moore.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 12:47=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Wed, Mar 18, 2026 at 9:13=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > Instead of storing the user_path, store an O_PATH file for the
> > user_path with the original user file creds and a security context.
> >
> > The user_path_file is only exported as a const pointer and its refcnt
> > is initialized to FILE_REF_DEAD, because it is not a refcounted object.
> >
> > The file_ref_init() helper was changed to accept the FILE_REF_ constant
> > instead of the fake +1 integer count.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Christian,
> >
> > My v5 patch was sent by Paul along with his LSM/selinux pataches [1].
> > Here are the changes you requested.
> >
> > I removed the ACKs and Tested-by because of the changes.
> >
> > Thanks,
> > Amir.
> >
> > Changes since v5:
> > - Restore file_ref_init() helper without refcnt -1 offset
> > - Future proofing errors from backing_file_open_user_path()
> >
> > [1] https://lore.kernel.org/r/20260316213606.374109-6-paul@paul-moore.c=
om/
> >
> >  fs/backing-file.c            | 26 ++++++++++--------
> >  fs/erofs/ishare.c            | 13 +++++++--
> >  fs/file_table.c              | 53 ++++++++++++++++++++++++++++--------
> >  fs/fuse/passthrough.c        |  3 +-
> >  fs/internal.h                |  5 ++--
> >  fs/overlayfs/dir.c           |  3 +-
> >  fs/overlayfs/file.c          |  1 +
> >  include/linux/backing-file.h | 29 ++++++++++++++++++--
> >  include/linux/file_ref.h     |  4 +--
> >  9 files changed, 103 insertions(+), 34 deletions(-)
>
> Still works for me.  I'm going to update lsm/stable-7.0 with this
> patch so we can get some more linux-next testing.
>
> Tested-by: Paul Moore <paul@paul-moore.com>
>

Paul,

As you saw, syzbot found a nasty bug in this patch and it is too hard
to fix it without introducing more hazards.

Therefore, per Christian's request I am withdrawing this patch.

Please see compile tested alternative solution for selinux without
intrusive vfs change at:
https://github.com/amir73il/linux/commits/user_path_file/

Thanks,
Amir.
