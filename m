Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7A3EE1C9
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 15:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935811; cv=pass; b=hPUVS7/DlSUgi4smcfHLseuiknkhsT7owRaJrr6ZfWklf9hpWZvaNhf+bQnknRCTK1LN1GH+3o75y8bSlshNqb/eZflF0iJlFedjsJFktCfksOcSbP/pCnKURwy0XLQvt1N/R9k6NxAsKT0T7K9I10CxLWaannalTSQkuDClf/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935811; c=relaxed/simple;
	bh=venfIdcDoNMJAHTl0dBp32zf9R0qjSHwm3If9NHEtBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKF4NQUIfQDD1dadnyY3XJcGh9Zvvzc4h6IeGm5mFIUpUsQ5hKx9FRS97MnW0eC5au/+jWi/zFTafV/DhlBbCm9aOmpx0axXU2f8MzsPQJHNGMyb7FZHKeNa5ZUi2pbb0MDj3PE+FUhPTo9psk3erAQE8QECmsyQQN5NVcIsnbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DykLok8S; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DykLok8S"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b0586d5bb8so6371205ad.3
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 08:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773935810; cv=none;
        d=google.com; s=arc-20240605;
        b=gGaCks9V1x4VXVe/02w3qEC/nQKaA90zlO9rAQBnh4dWZmKhS23glJQWo3RpC79wCG
         U4fM5HTB2jt/qGoQJFWKJX3RyXF/KdGzASa64MMZOYhARCKrtD2J4+QOC6EK0Cv32OyE
         rdnOnWueBk5otTSsAWea+LZYVsGotn8PvKIQc7cF0fejmp1+FGcc6hnYqmotA7Hq3mgg
         EFni96yPg24yZzTzjUGl3b/lxhBg4LheTOZ6E5IiR9LVzcfXR7VKN+tuKCFFl4iN49+C
         okurEJW60CR4qtGuDl+UZUEfXe+PlI5oH9NiDzq9T8n/OHI7KnXIdxsjkCcZEOCgy/RX
         5HjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TpNQ4RrfxDr8OIdp6sqWlPi70JqpMY9icBlXfAIsbA8=;
        fh=FtVHdqBMbqPSZJjuRqxcQcVO9qv9U8eCxerj7vVMnZU=;
        b=S8AARVoTif82/EWId17BoZQnd4m/UsU5R4aNoy88ydVxMh675/JZtm+CZcSBgGGyYq
         u4y9c8699Yy9Ib/k2eP+eg4RIW87DFbPSLuFAEeOEZEP/Spc4Ll1aW2VQLAewXqf7tN4
         jWa7RF6RDbM0ZkaDSYNiVFmWdOg/mxCUJxtwnuz/rQUCXa9grt1DGQh8H8rdJ0vBP+ta
         WGWuJyzQ+tMINRXtYlZCMIwEgZ4Z7VuZ/XBzesxD0ayKjOKjrmJ67esh0R9JzQbnRcxm
         +kkuGrxe+eeXiqerzzneQmN2dkqDWyMXE8ZKgdCLySnmHbpeP/qKr5/+d4JLI9vLJZN8
         FzTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773935810; x=1774540610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TpNQ4RrfxDr8OIdp6sqWlPi70JqpMY9icBlXfAIsbA8=;
        b=DykLok8SsbPuq+JrybVVuynmBc8i6t1bhey9okzn1CetJdy9MzCBXvv4ZfsvnlyFwh
         qWh4iHHNLfOzlH60EadF7cwaVNVZ55yFjuUWkCFtr6mrDRffjdYC/nF7lTMZ1EMNY7/a
         jNEvFB6mlX4v9Vyrtp++TcJ2fdxVY2okPOmOp+TptqhCJrfJTGY4im+/N5RUHF8l4/2A
         Fpq9ISSsGQvoPlkHJNMhlabngLG8Xkn0lUfQAtFCxuj7y0fFHRKoq4XgdriTZndnT5d6
         DZg/WcxcP/TVZedeaT6tufUe1FKDfcXtnkElvzrqpBM2Ynyu7X5Hk6ZH4U6IIGCsJf70
         tUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773935810; x=1774540610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TpNQ4RrfxDr8OIdp6sqWlPi70JqpMY9icBlXfAIsbA8=;
        b=mApNeEnBCUntHTetO7/0vERxVqYIJu42iZ5EbnJuJp9XsNmLuk1fVNX/tG4+XchX7A
         KRWiyuCucbCNDwqszDSp5SCmuFNl2eLRYKk3HN4NPkg6YfuV5fjEsdZyND2vMEluOdh0
         7EZ6qTm8F4oLRNgs/tLBBeXP32YBGmJGk2Vw5NnwRR68pUFeUKxKC+D3MyJWjOTKPQ4j
         gNTKQqJYLBR9QURyVy0gE0lC2TcqzGf/DdmWqtwCI/R0U8L6mhdkF3LYTIOEPMabqKzg
         A5K/o2E5nWkgzpiWAOiAq2JdnnbLG22FNuG4Cn8l0a334AlfguO3qpywsieb1m9Nh+mA
         4gGA==
X-Forwarded-Encrypted: i=1; AJvYcCU6eFVT4Fcy0M86RpoMWXXA7GPRkqKNhH7QcOYvylT/goZiXu9Q1tUsAhEWzjBClhkBMVZhgCWKEw2ksyiv@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Ox0GajYYSfQ4VfHEx2Z0skLdfScdxnE9sUDHZfDs6LOCXwwy
	RAqXuLKlK88hkfNqDyftbDePKY0iqE/GO2n6htZemR7F1t79cobHqimML4EUjgljv3Vvre3LrIF
	TeQI9tHYUGwzAn3JsyYJPks/MnN3zPhGE73RC+kIy
X-Gm-Gg: ATEYQzzYGhxpWEamyoy26kVigGvBlCaLPSXx23DFSuCQRT31DDbUt5TRgeuYy7WM9/e
	04UdZ5DoZwGf7t/VKMBoUM05v2q4SfAWs36EY8iwr4BVeKFOxXWAlQtek3HGEZgm8oEhkYs0frX
	b8E2Cg5u98dvrgOQLkCbdhNuPnZST48WffDKrbVMaK3hxTZVg1IzQ+myYJKblZpfeLRGefurdbj
	4NRefai6zPzDPNUSJomjO/QO6PPGAzdYD5O8kWYMFMabXkf+9hijJJ/X36Zm2qzhNrund5ekvXr
	A7PWKN0=
X-Received: by 2002:a17:903:1c3:b0:2ae:478f:2ec with SMTP id
 d9443c01a7336-2b06e3dd59emr76386305ad.29.1773935809817; Thu, 19 Mar 2026
 08:56:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318131258.1457101-1-amir73il@gmail.com> <CAHC9VhTKvOzMS2ZyawE=qBN-EpyucfxvwcHZYjXF5zugRhE2rw@mail.gmail.com>
 <CAOQ4uxj8SZqaFbrVifw0uw7skbUvJP1_nLWj4PYCeZuaLy5t_A@mail.gmail.com>
In-Reply-To: <CAOQ4uxj8SZqaFbrVifw0uw7skbUvJP1_nLWj4PYCeZuaLy5t_A@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 19 Mar 2026 11:56:37 -0400
X-Gm-Features: AaiRm50nhjVBL81kDULwvCn8PsB2aebm_MIqZayk9nG17bPp4IlB5KlFJeWc6p4
Message-ID: <CAHC9VhTXfiENo3MVSv+LZFx4VJGTDqErMBKx0wx+jKNOc=NjSQ@mail.gmail.com>
Subject: Re: [PATCH v6] backing_file: store user_path_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 10:54=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
> On Thu, Mar 19, 2026 at 12:47=E2=80=AFAM Paul Moore <paul@paul-moore.com>=
 wrote:
> > On Wed, Mar 18, 2026 at 9:13=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > Instead of storing the user_path, store an O_PATH file for the
> > > user_path with the original user file creds and a security context.
> > >
> > > The user_path_file is only exported as a const pointer and its refcnt
> > > is initialized to FILE_REF_DEAD, because it is not a refcounted objec=
t.
> > >
> > > The file_ref_init() helper was changed to accept the FILE_REF_ consta=
nt
> > > instead of the fake +1 integer count.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Christian,
> > >
> > > My v5 patch was sent by Paul along with his LSM/selinux pataches [1].
> > > Here are the changes you requested.
> > >
> > > I removed the ACKs and Tested-by because of the changes.
> > >
> > > Thanks,
> > > Amir.
> > >
> > > Changes since v5:
> > > - Restore file_ref_init() helper without refcnt -1 offset
> > > - Future proofing errors from backing_file_open_user_path()
> > >
> > > [1] https://lore.kernel.org/r/20260316213606.374109-6-paul@paul-moore=
.com/
> > >
> > >  fs/backing-file.c            | 26 ++++++++++--------
> > >  fs/erofs/ishare.c            | 13 +++++++--
> > >  fs/file_table.c              | 53 ++++++++++++++++++++++++++++------=
--
> > >  fs/fuse/passthrough.c        |  3 +-
> > >  fs/internal.h                |  5 ++--
> > >  fs/overlayfs/dir.c           |  3 +-
> > >  fs/overlayfs/file.c          |  1 +
> > >  include/linux/backing-file.h | 29 ++++++++++++++++++--
> > >  include/linux/file_ref.h     |  4 +--
> > >  9 files changed, 103 insertions(+), 34 deletions(-)
> >
> > Still works for me.  I'm going to update lsm/stable-7.0 with this
> > patch so we can get some more linux-next testing.
> >
> > Tested-by: Paul Moore <paul@paul-moore.com>
> >
>
> Paul,
>
> As you saw, syzbot found a nasty bug in this patch and it is too hard
> to fix it without introducing more hazards.
>
> Therefore, per Christian's request I am withdrawing this patch.
>
> Please see compile tested alternative solution for selinux without
> intrusive vfs change at:
> https://github.com/amir73il/linux/commits/user_path_file/

Let's let this thread die in favor of the other.  I'll already
commented there, but the quick summary is that pushing the ugliness
into an individual LSM, or the LSM framework itself, is not a
solution.

--=20
paul-moore.com
