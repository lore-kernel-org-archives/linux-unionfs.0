Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566063D5656
	for <linux-unionfs@vger.kernel.org>; Fri,  3 Apr 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775250886; cv=pass; b=LMGXM6WdWd3JHZoAsWYeIEOik4ZsuHUlB7CbUzHe5KeYYq76sAV5bpN3cDNWzgtFIVOZO64lbKrLsAux+joTQIb1FC8w9Q3ZyJfOfP1FX9VQiVkQLJ+4FQ82XwKvqLFzAAzmkrA8g0ikAvOstmwnnmDRkQZOfyVuFoPUFOLGoKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775250886; c=relaxed/simple;
	bh=iNQ9qdRSCL3uUh77rSWYNovDUs8lKN7UfJ+q0K1jN/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fXUK0ZSjGknNdaPu/+SvaDzznHuyjBWtL68LPiWmhLvSne6OOlVDunLr6t1+JW++xd6fm2RaGKQq7Rz1Wfze8LFFYnRy0FCb41vHzCkFOrBg1XNKw3mSgZon6KGrXhS6yvfLempvMnzyCMjCWVdmp/M8IzTnrPOE9IQ1dgAxQ8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Ie+RQjJA; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Ie+RQjJA"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b258d93ffeso12968855ad.3
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Apr 2026 14:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775250882; cv=none;
        d=google.com; s=arc-20240605;
        b=GRvzEnpmgwcVMi5pv2BRydtEosxOTs4+15iCU9/CBHjP0KmrVQ1XASNHUKa359r+YR
         4nUCsrzOvi01nDEGD5c/M9v4lySjDij2kfbAhx4AoI2WmhAu6eUyxzea1+dBdQTJZrBU
         udxfrzcGhvpf19IS+XPrY6Df6wpORuFFfNxEB9a8skZ3mI62jWrGiG8YvqEYcW1fbUxb
         G+b8NA7swCoW/k/dNRNvNJG3kgdaq/1rHx0iN64E6Jr6rYFC2G0QHC2hprgKjpos52GO
         DXz+3qRFaohu0W88Tv3XRyPPdlf5KSKPih6KGIJo++kyvunxPi1LSn5trvExl0QIi1eN
         cnkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZQ7m/t07ozBolMzvyENjzR1B2LhiH3tODVUDturdZZw=;
        fh=Q/137rOHNooQzDJjsA7jUgFb/P9y2bY6lBRnJaF9pCE=;
        b=HRKqopP1bSXD8aEDwV+sUOWoIZjxJ38Tvk0jrXNr0/ASjnTxObKplpM1Od4F2SxdQ2
         DyH6zZPuAhfCCFYT67/zyaWjP0qNGTlWMqWzowcblQYvWWa7C45qvdDSOqX4rVuGig25
         c7KpI/96vpJQcjtFq6fG3f+B/MsGx3wt6XtJQJwQh1OuU+MLbQxlng6PIyigDHLGMilg
         qVM6dIWx7lO9O/7o3DgsXhCRifBaFHZ+FMCqzGMP+06ioM/LufoFaKUBotsGcenasjW+
         9Gpugezcz09oUVhDJL6KGE9eEbMx65ToO0Ta7h3p+l8iYtanXSrDmiYA3Bwxxo+fIkgl
         tgBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1775250882; x=1775855682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQ7m/t07ozBolMzvyENjzR1B2LhiH3tODVUDturdZZw=;
        b=Ie+RQjJAjFlwLmuajd1+bQFaYVKDGeETiNfVlqMIuyVr+Arbdhb582dBjLK1c8gUvz
         O7uOwOG2Cw8nmaHA4crKYPsQeFFt1DZfnmQ0vwRALKMdKAbfFqoj5zL3pkKOST/w9yf6
         0amZgjxpk4U21DzkcEx4K3iJ3dylBGnObQEqbb+gdlw9I0DjU/gYNG5wOmWfPz2S7tSn
         MXghGHq0GXeZsos9sS6A0Q4DNZYmfQvOgePBu2W4K9Bek+r2hA4PQqYUxRag/j+b5Cno
         k9dx5WSBP+5AzU49wkTMU1itGd7DEnC6/pxwDRHQoVuLkjvMZGk+VJJnmHLzYuz+PXJE
         H0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775250882; x=1775855682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQ7m/t07ozBolMzvyENjzR1B2LhiH3tODVUDturdZZw=;
        b=qYzMFZe8bhN3BjOn94v6kP05gkhY1EHezgRzD+/C4Y7ZL00ZTWb77OPb/tA7JbtSVj
         tCmuqo9PxZSmLQ/zuJYocCVEJ070EhO0AjCpCChw/SqQQ/rJD6Nq8cKOxmnW3WTjWM3a
         Uw8fNfTh/cf2KUejxre3LnKQFbzf3H7xTIYsu28eT7dOctgvrmJ5GbITx0hHZeyLSnW6
         S0g85RycxmK7b6lK74NlUC0BjMJUBl3F8PEVMQDR0+SrpENuH2gIHOM9tEy6C+ZTHEBh
         rv+38LguDZc+1790qwpNTnCvn3MceNagz+pHaWeqzmE2aqxsoG7c6qLcEU3bPmnqqONU
         XqEg==
X-Forwarded-Encrypted: i=1; AJvYcCUw30GTO+apjlTHnd8MoETCne0QKQMAvySBvGQlPsuqJMZQH+GWY8PLxh7SwQzPHiTaMdJU6w6+skSIjH4N@vger.kernel.org
X-Gm-Message-State: AOJu0YzQaaQXZXJqTRIXWvcctoUODdfjNBQ2lbTqWN6+ebaOAfr80MrE
	nz8K8FVr9uIs4U3IFdqxlP0y7vXMlftKtfroXf8R8Udf8TdePWHJ54efcTFS9wX9eM8+ZWNPMZe
	Db8Hw5+GvbQ0KsIF3HLv1e9lQf4LEM7RiTlhN9lMh
X-Gm-Gg: AeBDieswgxgK13e5S+wWGX4Us5ytK2S9g8q7ntGR66vI63MvlchC2tGoHzQwXqudG+P
	c0GQ9H4LiE3ZtAO4efSr03Trrt++gc5hYkhXJBMuhGXOIf9tAlEgmDL9vH7PR7FC5muindJol2j
	9xDPujeKQ9AD/l8fSQKCCnuLSBegmx8hqKSbbESuQz4KlM+3tgwz9N44LVXJ9NUKiSuv+4Chkb9
	6n8x9mJ5I9o6jezUqJA2Hw0NFsMwFHADlzOAhf9crYLB2SKTp1wcSvYIrkKQnNbeNj5COEOFARG
	um0GBAc=
X-Received: by 2002:a17:903:2ed0:b0:2b2:5091:1c26 with SMTP id
 d9443c01a7336-2b2816d8626mr47571725ad.22.1775250882586; Fri, 03 Apr 2026
 14:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-7-paul@paul-moore.com>
 <CAOQ4uxgd1wo9U32L_sQLfswY93LRp4yPzkJvKtj=wDKi8h13gg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgd1wo9U32L_sQLfswY93LRp4yPzkJvKtj=wDKi8h13gg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 3 Apr 2026 17:14:30 -0400
X-Gm-Features: AQROBzBl5cCyhzn_4rsiKSOgf99yuNguIB3BwaumzWCCJnTdkerDXkp2yfIst38
Message-ID: <CAHC9VhTyFJottNM-Reg8dGbU4T_gAG63oOQjwrOY0x=2sCLR4A@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] lsm: add backing_file LSM hooks
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 2:12=E2=80=AFAM Amir Goldstein <amir73il@gmail.com> =
wrote:
> On Fri, Apr 3, 2026 at 5:09=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
> >
> > Stacked filesystems such as overlayfs do not currently provide the
> > necessary mechanisms for LSMs to properly enforce access controls on th=
e
> > mmap() and mprotect() operations.  In order to resolve this gap, a LSM
> > security blob is being added to the backing_file struct and the followi=
ng
> > new LSM hooks are being created:
> >
> >  security_backing_file_alloc()
> >  security_backing_file_free()
> >  security_mmap_backing_file()
> >
> > The first two hooks are to manage the lifecycle of the LSM security blo=
b
> > in the backing_file struct, while the third provides a new mmap() acces=
s
> > control point for the underlying backing file.  It is also expected tha=
t
> > LSMs will likely want to update their security_file_mprotect() callback
> > to address issues with their mprotect() controls, but that does not
> > require a change to the security_file_mprotect() LSM hook.
> >
> > There are a three other small changes to support these new LSM hooks:
> > * Pass the user file associated with a backing file down to
> > alloc_empty_backing_file() so it can be included in the
> > security_backing_file_alloc() hook.
> > * Add getter and setter functions for the backing_file struct LSM blob
> > as the backing_file struct remains private to fs/file_table.c.
> > * Constify the file struct field in the LSM common_audit_data struct to
> > better support LSMs that need to pass a const file struct pointer into
> > the common LSM audit code.
> >
> > Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
> > and supplying a fixup.
> >
> > Cc: stable@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-unionfs@vger.kernel.org
> > Cc: linux-erofs@lists.ozlabs.org
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> That looks nicer.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> Thanks,
> Amir.

Thanks for refreshing your review.  Since we are at the end of -rc6,
it probably doesn't make much sense to put this in lsm/stable-7.0; I'm
going to merge this into lsm/dev which should give us at least one
week in linux-next before the v7.1 merge window opens.  If others want
to add their ACKs/Reviewed-by during that time, I'll update the
branch.

--=20
paul-moore.com
