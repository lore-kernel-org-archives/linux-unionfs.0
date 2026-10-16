Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECE526C385
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Oct 2026 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133886; cv=pass; b=JzSGtey4kKI/dlor3a5YXidw7VIugr1t4TtqlBAW0Un0HXe3n9g+FzSZfa5d1yKbDgFe6SDktEbcBQPQjl0tYJ46i5bEo3jXkMPCx1o6So6LJjAH0sQFEze2afnsZBYconGYyDh5oowjdQUF7hROjEEM51AhgDVP4FYtQGuvz0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133886; c=relaxed/simple;
	bh=U76ebMoSyTQsuVPgYGLotffYpp8DopeIDr7nhIKrbho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fREgAsIskz8V/KwJJ8PYxhommmUEGKUND0ItYliOC3h3XbMT45aI7Ks46iwgqDVVLIuRb8kcRIDT7JmOj+0r2nc0EH3HpbavHVFnBivWpmC0FjszSJSzdR79t/tPM6y3cRVwRixB7mW6lB/7ZPpiMT68WNmCU1xLgLhzZRsSzQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BugadP+j; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BugadP+j"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b1cc392d8bso3849302a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Oct 2026 23:58:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792133883; cv=none;
        d=google.com; s=arc-20260327;
        b=CZKOv2RSQRpJvGDnrD5QFjXmtM78ulZN5/v2OB6XvU+QDsSJo80z2HMFA5SQ6xrTvn
         NPWta5+nA7fsqLsETtj0xSSsSwSE7IsWoJJRcjwEwsBsIzWW80BNRSUxJLzdY1yUxFIr
         GQ+Yv4uzy1PIT7i6pVm/Q0IZCj0porYMzobhONLF4RXl3zHuc/2EuuAakSICZGNtnx79
         7jT27AvifPWWtTKJAE/3ENhu8Z7UAe5H1wtZcnJqE0hyEaWuls93DifYxLSYp6Qw6byA
         tNu6bPvgQ+NhKcvly/j2Xlmt0C8FDDAexLz+nw+bgb4c0aN6ZiVMtQWymBU5K42ju9//
         EzhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SLmKggqak5/Dj+cuhyZUgxKGUgEOUrXFwflmJJiDsks=;
        fh=VBRNFJtl2lez5bVdFVpJA/wHmLQBhpXeHk+QElVf8b8=;
        b=qjNM3GatMEfDIyXVhQgj3G6hIvEF42XhdPa80rXWgvCcBdp8WsxE3fQAIz43cXjYfY
         kCvCT52bLxEp/ZzbaPYLN59JQtF3lblDhr2QZocZghPgD9N31tRVSCnUsG000r0o6SBi
         La1bbJoGNsJtdvrJGe8x8jRJAXu8xB5aIMroAZEAKkL6XQVXYRJHfbkKS6r57ekjwI56
         YmHkQ+Rz18vD86lR5re+l9J0YGH4MixV6VGLDi0gSlJHHePi4kqzcC3TjlAMiN+sO8dY
         7eKHyIFhklku+rkf+DWdEWa5PXEvZcwAJusvXavhMUoKHtCWli3WzwI0afBQ5VKDH76X
         EO+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792133883; x=1792738683; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SLmKggqak5/Dj+cuhyZUgxKGUgEOUrXFwflmJJiDsks=;
        b=BugadP+jf8T/v67A/JZWzdLRyW4AdJANwF79NplWKBXhKgdrT0gT+DKp9Nc96q0g4i
         7SsTwmyUVBckHll0pINvBD6Kk9lE3rYk41B1Rc8/pVVxuxfXEP7T3Hgqd6K35uebzOeU
         ftYZo+a8UHNm5Dmj/4/QMnDbLDbaybFVxQxqNjUy9h47XJ1LW8b8HtDpiHCcQsRasznw
         cvlaB6v2dNUcYfOotwIvATL72CllhzEMLPQh2wbFjQ9Hf6uILynFO2XQxabhETwzE2+Q
         I8BTsP/VqZk500g3spKzLYEheOgoVX1iywgT4m3F91Nshu00qpYPudpoDlGrwKNA/55H
         JXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792133883; x=1792738683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SLmKggqak5/Dj+cuhyZUgxKGUgEOUrXFwflmJJiDsks=;
        b=W9bgDe+m9TjJBMuQkqmEQm0OkINsGpioXWK2aoJpQYx4X7p+F6dQzsZbEnG0TD8wV7
         bqI5gfXhespdoXsWaV7hhJsPJyHng9P4l1wsJpwqIAvkDv+z/VuksRRC5iPOj78X+cND
         AipWS+mpMCtO/d0gjR+heGoTQ/Twxxu+RRG6aUQs/5QXLNavOdFFiPF1crJA+JzrxIwI
         xf1B2qMqDpUnvw3o28TaUJYdD6qoprzxUzTnclvDjZaAxURnWiaAa2MZEyN8lwOMio6z
         9ewAmSP1W5zJ+2QDtTzTzd2QWS8MNmbrFm4V0s8a5BhQhx6PILRGyOvoPCry89BMGhhW
         NcNA==
X-Forwarded-Encrypted: i=1; AKwUvBwoJRYOJ2GovhYgTae0pO3+c9I+OkYTGCkXc05RfLkxZENQpBU6DQ7KM+zPjI1dzocKJUCoQZoySx7ZU1Do@vger.kernel.org
X-Gm-Message-State: AFq9FYJCe7AicFN+awO1KgjC+Bhv0tGS2imokHyqKuYw1uSiZedc3scx
	XP5mvCc4yTrp7XyZz90LN/ne/ZN90uo3eAoi9kuC3NleKS0i9kiM7GJJ6FUQWhwwMHQ5kKLbrK+
	vMk53EmGfSARwk0zETZMgXn4Hnw/dtoE=
X-Gm-Gg: AYBFou053yBQIgYj77JrDGLf5xgvN58nN1cngR8NoG8iRAFWNupWWXmW76QEW1p1ocO
	u9wRN1DuqtciEhUq+WwwHpE/0zOdLB/RgtuR6Df66zCUx95a3vIqN4N5N8UECNwNoeCAZju8nRr
	LwjTuYj6tExhOeWVbfzcpbqMMzQ5zXyP+6s1P9mK2oxyPvHoja73X82xOfLwb9EM/WA0DCFDAuz
	Z9rq78Av2wQEryVHTp3pu862anSgPq8eeSS2hVAp7tnyjdPwqCXFVTQ4DLukLD9ssJ+6E0a+LRF
	LYJPvUuWbggq2rq5WCmHh1bsvQ3pJnTZcgOd1t5/I5gaM3alSL9MZJGB
X-Received: by 2002:a05:6402:5006:b0:6ac:fe75:16a with SMTP id
 4fb4d7f45d1cf-6b17c21c293mr17047655a12.1.1792133883273; Thu, 15 Oct 2026
 23:58:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261002223746.3248726-1-neilb@ownmail.net>
In-Reply-To: <20261002223746.3248726-1-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Oct 2026 08:57:50 +0200
X-Gm-Features: AclHuK9MH6B6PzJPsaSzlLYudYyT9yvA5ySybSRksoXyZI_T9lFw0oouAp4jzR8
Message-ID: <CAOQ4uxhkGPc8Wiik61_9-u_Jf=gUx0Z4EDaW1z=FMhx73oE_eQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fixes for dentry lockdep tracking on stacking filesystems
To: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, Jeff Layton <jlayton@kernel.org>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 12:41=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> The recent addition of lockdep tracking for in-lookup dentries didn't
> take into account the needs of stacking filesystems.  For this we need
> different lock keys for different filesystems in the stack.
>
> Thanks,
> NeilBrown
>
>
>  [PATCH 1/3] VFS: per-fs-type lockdep key for dentry in-lookup locking
>  [PATCH 2/3] VFS: rename lookup_map to dep_map
>  [PATCH 3/3] ovl: provide private lockdep class for dentry->dep_map

Christian,

These are fixed to the series you have staged on vfs-7.4.lookup

Best append them to this branch per PR?

I have added my RVB for the ovl patch.

Thanks,
Amir.
