Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8EA16EB65
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 08:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724314516; cv=none; b=AKKy2ufyD9Q6oQNTXPX/dysPRCdH2IYNhDk2PCl3mUoqo2Yp4L3gpYhngJZwHmkRFxT+nXPIlowBZQnnMpKj/PLjRGxgn8dhKpLuI3z7IqKWPIefUjmNrdpV4WPgk9/XoD9MO9VpYi/enIca7eAUiqwNS+NIP2m4zwDlQka8nBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724314516; c=relaxed/simple;
	bh=LQg2LikSVh4t6qUG9/JiYVMdVBSK+0WTTilbAKFAUcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AjNyMozZKb2GSLNBAEDABL0ms2YvKsd1IzxMcjOG53ek5T1/6izVcKvpA0T60z8cNCyAf5TFsDYXtw/G3hDZy+60Wqz2gwZDmFP7DC2medsvwRXnan3C7tFMXskLk/j+s/PvE86JCHjgnisdOq14Xodup1vQpmdWFGBw67iW9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=XQzLSx/H; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="XQzLSx/H"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52f04b3cb33so853678e87.0
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724314511; x=1724919311; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uqbG4nW5Y6BHbHkXKVf6nVFJEVL3TwPzeJDq6NPW2qo=;
        b=XQzLSx/HKg+X/ALxTZuew+UMnOIvTcvEafXLyYr6F3tj7P2jigajL/ve5ujEdLQimN
         Ld9+g1C2Kc5tk6F+d4KLKrjybHnRnXiIZJJXOhWVWt8Svq0n64QA6+7+qYF0WtPJNyTr
         e95OtRO2q6fa71+l6fQgp3YnZgM/JqgkI+i00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724314511; x=1724919311;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uqbG4nW5Y6BHbHkXKVf6nVFJEVL3TwPzeJDq6NPW2qo=;
        b=j0OYmm6EGVtBAAfSOFXXMU47mlNiWc7oZSnulqFhd9bjUjb/U7LMRxade83IP+UcOS
         +CjAyTzEV0Xd5FJgJBCdT+hcCoaxgSYlxh5ZNLh0y8gWXwEDjWMcTdSqBJBZzGHKcHLc
         P8ZfAuyu7iVf8BxbR9+aaecOXSwUF48S4LRCKzSkGLbELiymMVa+G5jLHTTbl6z4LZ3K
         yjWdpylCBMK2QUjaLQBNwZeHPlFrLWhQVL8ssKwLfTzd5VQ6bPO3sB373vaG8XtdttX+
         cwUuOxoFbRhvKHQVt7XgNsjL0iOo0M+6bzWlD7PH0TssjTeVKGyxHxw5XLculhOvRT+C
         ensg==
X-Forwarded-Encrypted: i=1; AJvYcCXBPxg9UYG4yixlMMIr3Chyp2S4C1GKg2dkGUE4oeutiPrCPx3mOlTEnuXmrq0yD2Ve0valJeuqPbKwBH05@vger.kernel.org
X-Gm-Message-State: AOJu0YzYXPS814ZXDNZCOS7kaqXm8mHu8AjKf1yXPtq9N5P3r8YQ53RP
	BKgKadwzgK2AmD51hAvGdUQnzkv/QMa7FZXXSx61jL/uduN1giBcELR9fCybzj9/wboOgrasxMF
	Zi+emYBMQs5leOkZel1YokS/pME1x4Y48QECKCA==
X-Google-Smtp-Source: AGHT+IGeEsWLwDn62Q3uOu1kuIfreyy7/gjPN+p1rXMKUOBZDfj3t2/mNoyV7SIAvs0yR/zP1E2sixQmJRRO8bfS9r8=
X-Received: by 2002:a05:6512:b06:b0:52e:73f5:b7c4 with SMTP id
 2adb3069b0e04-5334fd4cbc5mr917514e87.37.1724314511188; Thu, 22 Aug 2024
 01:15:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822012523.141846-1-vinicius.gomes@intel.com> <20240822012523.141846-5-vinicius.gomes@intel.com>
In-Reply-To: <20240822012523.141846-5-vinicius.gomes@intel.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2024 10:14:58 +0200
Message-ID: <CAJfpegvx2nyVpp4kHaxt=VwBb3U4=7GM-pjW_8bu+fm_N8diHQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/16] overlayfs: Document critical override_creds() operations
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: brauner@kernel.org, amir73il@gmail.com, hu1.chen@intel.com, 
	malini.bhandaru@intel.com, tim.c.chen@intel.com, mikko.ylinen@intel.com, 
	lizhen.you@intel.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Aug 2024 at 03:25, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Add a comment to these operations that cannot use the _light version
> of override_creds()/revert_creds(), because during the critical
> section the struct cred .usage counter might be modified.

Why is it a problem if the usage counter is modified?  Why is the
counter modified in each of these cases?

Thanks,
Miklos
