Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6752EEE8C
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Jun 2026 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780654625; cv=pass; b=VpNSQ3t5BkKAB0UkeAW9NQ0iRwepK35wv4hgPD6pPcv1VWRIRGV5wpA6Vzi/MaeDjh0V3isxCXu5E16USM5MeyaScyZRTA3RR/BVf63G3C9KsvjqeYtdpKYlKgu7KjM+b1gVwmpN0EHlM0uPXXFncYAlW8GIfu9R/f3XrQisAcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780654625; c=relaxed/simple;
	bh=WF1vL9rONde+7EdvH7Uhhegwq4EwzF5oUtUzFz12QtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fWY5P6PBxfGSpYVNn71eEsdl9DBX64J0SaEO4V6qdqjGdn4+zFZxHtr6LRn7RUq6eQ8lWtbI7wjEUeDc9MDowxikudXaBAag0ERVR55kIMlOQGoaRE6xmbUz1NM0jG99EVa5gy7p4MRa25G+rYSNnI04qj6/4kn8bz02ajBqX4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+9vUJST; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+9vUJST"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6886be3d39bso2354404a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jun 2026 03:17:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780654622; cv=none;
        d=google.com; s=arc-20240605;
        b=E0LWwRY2RK4purAxrxQZimjrDLUtUV3DyhEVJzOfzFA/ogwAAMWU/KVQWh8HzvSg6s
         TWKKntKAzHCadIJDejixmiObufVr2byjtQYOMMv2xeYjLUlZ5aio6tGLI8KvyPDGuJNR
         XWGpb6hbcLZMja/oBY6wjMt0EVzdibobZPDnF5hZNf9jEpelyqdF30S6oyiODCbitJT0
         iDDL7D8TaHsOFQFR+hvFIUyF3DJ+naNbnr8GKCpjp0z97F3wHRhlGWu98uhjI8i4lTWR
         /Rzw1YJ7Sirg8o8qBg2tMc1SaZM22PNzhf95fGaCLWOuauK1npWrWpyObcwfS9qbNq7P
         8RNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bUhFysbZlGjq4fEHkg5MW+w54X1b9N3UpX9VYOCDIRU=;
        fh=eX8mpF/cHjvY5ms3y8w4n+SOMrsoJuYxx2l+Gr+IBAQ=;
        b=PlVKtG6/ryO4ButP1n4U7ZD3Liv57d2JLQsu7Ntgq3lZFRUQzZJfK6Ywnu5IOV2uLw
         G8KPk7ad+UqD6cf2qCojBcfqbq7YTMjXtkjjAZ851IyvIYwORgdkGu5CSZajgTD006P6
         EGCvsqWcVGfrSoFxNQQhkrGbi/k4NlMNRiZdltz7vjtz3g2PpvP1RntFQlCpf6D7gsQ3
         1aOepLC1mnA9QbaUflrnqauEjr+gA6T7M9SKcWi+uivzLS+efi5l5WKW5cXgk54CWXLz
         +2fwCyiKXR3MPQeJFxp1BbxK8yHc3+aLsL01s4wyuSRPqsNBhDRUdYXakEOu92YRgzin
         BEAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780654622; x=1781259422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUhFysbZlGjq4fEHkg5MW+w54X1b9N3UpX9VYOCDIRU=;
        b=G+9vUJSTXWKm8O3eATRdhphA07y2DhvZrPOH5Wq91/zJq3PJ8cEPzEgr1fq/8gYwv7
         aJ46/Vc9FbwjfMQJbWB1t96yDJ+B5KcLpTPQ8nsS/IKtIU6viXvPsEXwTynWVdZwX2H7
         pzW8gCInImWsD9OSHoJNDKi3H5lSgFDloIqCjG0EUJWbtiFA+U0dNyO6DPC+T0Qrof1Q
         +kLPB8d0n/61mS/zIt3XUMS89dBW8OfSkiMBX7u/iofBzqPsL6rM0UWxtUEXcDdxetJW
         fVAG0A/UbzXE9Rj+a/7pY58ESue8ekdR5y52zTH/zZVCOVZfjnQRGQuGvLKAKAt+hZdB
         NfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780654622; x=1781259422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bUhFysbZlGjq4fEHkg5MW+w54X1b9N3UpX9VYOCDIRU=;
        b=BoA0ub2sovEJru8ub2dwOYq2PWPeUr14DwrztzysRYoXtC+urx1hxZ63qYWKad6KO8
         02r46MZ3DA3vi1899+FxPICG0MwjmqoAE1qj0SWQQTL7Qpm7WUkMntXGG+kTIoucxZtM
         MVSY9sjuFLFTV+JIQq5l5S+mR8jRZm82wS19qdKQalNp2RVXDhNrkRaSOpcO1akM/6CW
         YV9MeYB7qUfqe2oXHfhqHmhgTuehpGVG6AgYDI7uXg7KUfWMGpBu5BmjKP940+R4TTIM
         KPRxP1obe8b8W650KUO+bPQBIzI3nj7ancXZaS+MaZ962nbq1u4KOLVb7q8cQb8eFEBH
         1WRg==
X-Forwarded-Encrypted: i=1; AFNElJ8yL8DOdPZpiPPevxkmrpYDjLAH8O5ta/318/mb9Cuy7tQ0LRtUDSd21SOKTUMTHd3vZS+ZV1oucOZk6nhx@vger.kernel.org
X-Gm-Message-State: AOJu0YyXh4kHNuvTJzY251OEerCV6UBmba3Cl+gqbbIccVQnCBLBQNCG
	+YOlDeuxlgLrMoJpVzinBRuu15u6fsdcS1Z9FnySUcbS0QBZliy0OAaaTCjEdsowuVJG1c5LQa1
	NZSfotaQWOEmDuW+80hkGTceBsdQnQrI=
X-Gm-Gg: Acq92OFwQdo9JM4SVY9NsR6/bGG3rdX+8Y7gwkn1l6Hhbd9Mmg/xDUwD8dn5Hcu1xZC
	NSHcTLF67i25i0717Q2Ql+A3WKqMRaU0Cpsqv1MvFzX3+oSgwPtv8IUrNq1g04uLrRQreJa75OU
	UHzcLyQFCXW4Idbgnh3Vm9tVIf0N9GqbTV+mpHeW1m3ZNZ8V8l77YmbtpIN2LiBUP2zr0NS27Tt
	wcoQ/hZbB1l0mGBuW46M/vcc3+pMeCr/TqtVIc7o6dDF6DdA/HGaF1nbqHbYEH180uz6IuAexH4
	/CL4X6npCvJVhoPgElGaafoUp3NTdAbKpBdGpeuS5VmF9OUZGemZ
X-Received: by 2002:a05:6402:27d4:b0:68c:33e9:bf71 with SMTP id
 4fb4d7f45d1cf-68fa4e18fafmr1527593a12.11.1780654622302; Fri, 05 Jun 2026
 03:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526085801.81187-1-liwang@kylinos.cn> <20260528104208.395757-1-liwang@kylinos.cn>
In-Reply-To: <20260528104208.395757-1-liwang@kylinos.cn>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Jun 2026 12:16:49 +0200
X-Gm-Features: AVVi8Cc1maywQKJB6UJFdpvjKJlWJs4NKrTH45EiYuR_zdidaMKJhOhK0HdykmA
Message-ID: <CAOQ4uxi4F=7pOUJfAJavaCZ19YoaASNssjuADqzUQs24ztLkww@mail.gmail.com>
Subject: Re: [PATCH v2] backing-file: fix backing_file_open() kerneldoc parameter
To: Li Wang <liwang@kylinos.cn>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, 
	Bernd Schubert <bernd@bsbernd.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 12:42=E2=80=AFPM Li Wang <liwang@kylinos.cn> wrote:
>
> The kerneldoc for backing_file_open() documented a @user_path argument,
> but the function takes const struct file *user_file. The user
> path is derived as &user_file->f_path.
>
> Update the @-tag to @user_file and adjust the description accordingly.
> Also fix the "reuqested" typo to 'requested' in the old comment.
>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/backing-file.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 1f3bbfc75882..080c99696cd0 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -18,17 +18,18 @@
>
>  /**
>   * backing_file_open - open a backing file for kernel internal use
> - * @user_path: path that the user reuqested to open
> + * @user_file:  file the user requested to open
>   * @flags:     open flags
>   * @real_path: path of the backing file
>   * @cred:      credentials for open
>   *
>   * Open a backing file for a stackable filesystem (e.g., overlayfs).
> - * @user_path may be on the stackable filesystem and @real_path on the
> - * underlying filesystem.  In this case, we want to be able to return th=
e
> - * @user_path of the stackable filesystem. This is done by embedding the
> - * returned file into a container structure that also stores the stacked
> - * file's path, which can be retrieved using backing_file_user_path().
> + * @user_file->f_path may be on the stackable filesystem and @real_path
> + * on the underlying filesystem. In this case, we want to be able to
> + * return the path of the stackable filesystem. This is done by
> + * embedding the returned file into a container structure that also
> + * stores the stacked file's path, which can be retrieved using
> + * backing_file_user_path().
>   */
>  struct file *backing_file_open(const struct file *user_file, int flags,
>                                const struct path *real_path,
> --
> 2.34.1
>
