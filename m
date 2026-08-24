Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354C33AC0C6
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 08:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787561366; cv=pass; b=lW/2yw+3vh5B892JIWz5fvdlSoyFYIiCABGFkCsVOvdU8TAJ0yTEiqxvOQhTxoA7s3FDmANVWd0F9tGxsUQN2vtGY+ypfCEk7aE+ACUykvFSg2rHNvDSniDaG3GJqzjCvXyr7wov6ElvTY4WJqyBKtgrWR7hg5ZGS+WtzFZExHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787561366; c=relaxed/simple;
	bh=Z9RYA2bvbfgj/2MAhtGLxMm0w+xK2OQ4murwZgw+gXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lb37c2/1OboNGX8A03noQZWIUvE3D52J0sHrx7xLHD7Rt0Pt6FgUHzP0Pvp8T4T65TaMYVaA6KNCYtASBPAtNTk6rFtW18TXdJgvsK65YRpBWt7tp7w17A841EQqNC7reBCUQNpaL/Qd1tDAS74cLI75Mre0A3IHxVfS6C1jRFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=hKWlW/vW; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="hKWlW/vW"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c0006ea8eso22496901cf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 01:49:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787561364; cv=none;
        d=google.com; s=arc-20260327;
        b=rnW0zcsbgRkPo7FRbM1nkmWgpD6T6gbM58MpppKT6i3gy1OaSBG7dmLpGFrfOGpC0e
         U/OPfgqBFZpghpLvpwESsScqOxN4MawTBQKfIOZiBf6ctBUJf4OC0RkY9yrrpZTUbJit
         /lXnsSvDp17nizPhlcjqihNJ3M/kJ9HkqeF6CAyjvYh9FfRnm8heTUaeOL0aTOHmJCUu
         3iuASRoRPV/0CqP+GKAiAVrfBIBwqF+hTBcWknCGRHy7n0uZTnntObPNJhAN6CwKiXil
         nKbAdpykbEjT7LzVII0SHdvqNDY2NKQ4yTU5paR89xE7GajwXw2UDwGmmpXMBqOOpTE4
         6BTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mF+rKgsUqZmZbL4LsNTYF3CpXuL40SjdECiZ2OOEAQM=;
        fh=FNoWG4XdVvIXKdrE7HbYPpUuc188K5Ufg5Kc36UEe2U=;
        b=bX3KvhmEZwIx8WPaSaSZqapV7sGkndNP5fwbmt7df/PbwsY+izFu3DixLyexTu0IIn
         gdKMCaguOBZQ4mYPJuFOTZ2Q7ZSaatCftkU/+7O97U9vZcaN9OoOEp3lM/HoN1EWZ2b0
         sqRb7X1FdC4ycnX4qIZ4xUPsF9e1CJzv1BQib4NQIIApUrGjeIVFVjcrfgJYLfy8kpxE
         8GbfnZ4ve65TFVqlqTDLIM79k+c2BsU0161vlzMUjnryMN871TYUSbchE39B1cKfsukA
         dm8rvWRpGTR0EI07hLk3NQWH6lpF6PyoQR7m28asdj2LZo5yBJxarDuXA0tpTN2y1DVG
         HbFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787561364; x=1788166164; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mF+rKgsUqZmZbL4LsNTYF3CpXuL40SjdECiZ2OOEAQM=;
        b=hKWlW/vWOh3+7sx6KgU9rcpy/7qfFid7jO8W8eSQHQQ8BROnwlyWcDWYxiWKqfXPid
         B45fmvhmxzk2bQHg06JhST4PLXW1KhqoLSeUZutmZI+PnUYGD4LkC7sdMfFEQq21AQTk
         UKJzAexc8j2v9MFxk2csUqRGTM7TGTOoafuC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787561364; x=1788166164;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mF+rKgsUqZmZbL4LsNTYF3CpXuL40SjdECiZ2OOEAQM=;
        b=cC/cT/h/eJKPx5NcyLEQIJLWk6JRuG92pCzH6dNo4sol548wOvAb5DNfQgXc8ay+u3
         vAmQ6DfloBcr1jhwa8pSbyeFaAIvsaPBqgiNA5c0NzcAfWMREoWlDfpPLnXdumFfFNsg
         BvasQARoOsCb1rftzAExt6SK+hq9Pn+cQm7INPAyBrcn0a0RHx1JTcaOW+EU1KotOScx
         nS+O2nmLLxFU+oZp3DSapdn4S7TQavSsSmQiFnU9nNix2Ai6cYxU/lBQoxMt5w4wtijb
         5I4xbffBjd1CIwuDNH3XHFc7AmxVbcnLD5erAL6gbrJQcWXWVeKhK6cdaJ5o/bENT/8P
         kqWg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/peSYQA3VMsH4h1ScLB92VGOCXy26CfJkN0tl95ynfzJAmIs6MZM9nri0byRR9DTtGmWJhAcd16FKjZpB@vger.kernel.org
X-Gm-Message-State: AFuF++mLaeEkWwguIf9QDTX+vL1BqNLmKvFVPhGg0TzW60PEhCymFPtk
	jwPK7Hm8IUj/7pbtNnA56acnfdM/oQ/SC+ipv3XFSFPoTwkxmlKYDURRTfd51R4r+rGuUTGhBkz
	DIdAVt+kOq1Zro//Ao05hMi0gvQf5o0XKq13ZY+bgZg==
X-Gm-Gg: AR+sD13/Nfjmme0fYO+OeqhNcLtOFF4l5N1VRqU1zvCKCmVsXQACaX+964/KiFRYH2m
	7xwN3IVW0QYYwtbKpvuFQxKoyp6H9Jn3MbQ8zLVMZ9jR2zbioT2Y5zB7j2EvX49AZ2k3r1nJFNT
	c+RcFT//ZKovM6/PxByuiaaxASe6v/veibbgZAw+YseUp5LEV9TQPlhDBffswOmp5y+wDg2TXFR
	ehhX1bJ+rIS+jm8zlBaeG5iT/dAPjPwj13vc4JLb9bDepFXSncJEvwweyrFNctElxvAXkacidff
	2L/eVy7i5bE2Zcb69ci965G/STLZLXSHH5lRuYNtLH9MKjjJQVN5CH4ph/WWh57YOvpbPJmVLaW
	cmge9
X-Received: by 2002:a05:622a:11c3:b0:52d:bec2:c34d with SMTP id
 d75a77b69052e-52e09cabf8fmr164046571cf.25.1787561364032; Mon, 24 Aug 2026
 01:49:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026082150-autograph-perky-e3cb@gregkh> <20260823224256.2724025-1-fahad@codepure.com>
 <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 10:49:12 +0200
X-Gm-Features: AcwNN1XiHQpN2m96GZUh3u1EugIhpxhXIVCPyqEKe5enm49poz0eCb4nkcZT6lU
Message-ID: <CAJfpegt1WinKmP5nOGv8Yx9VLf4Mk1ojg7e3xR5iUz=7yDAh0Q@mail.gmail.com>
Subject: Re: ovl_copy_xattr() can write uninitialised heap into the upper
 file's xattr
To: Amir Goldstein <amir73il@gmail.com>
Cc: Fahad Alharbi <fahad@codepure.com>, security@kernel.org, 
	overlayfs <linux-unionfs@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 10:29, Amir Goldstein <amir73il@gmail.com> wrote:

>     size = ovl_do_getxattr(oldpath, name, value, value_size);
>     if (size == -ERANGE) {
>         size = ovl_do_getxattr(oldpath, name, NULL, 0);
>         if (size >= 0 && size <= value_size) {
>             error = -EIO;
>             break;
>         }
>     }

Well, the whole retry loop is bogus.   Just use ovl_getxattr_value().
That one could be fixed up to return -EIO in the "size doesn't match"
case.

Thanks,
Miklos
