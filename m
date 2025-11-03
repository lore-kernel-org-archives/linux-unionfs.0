Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E22FABFF
	for <linux-unionfs@vger.kernel.org>; Mon,  3 Nov 2025 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762211090; cv=none; b=EMKwk9Blep+/SxPqtteD6OluwEYa2RFMCTCXqXoO5HqMwGZkaesiEDh0uGHjfdWfHsS6A9rs0EYJ34D3JbdzwQTPFA7DzhBADkhIsL8iVyRMQZb9YtNH70buJooZtzY9E/FPv7KHY2aP24K8kjDE2meNRUnrXT4H0OVZHKqXvug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762211090; c=relaxed/simple;
	bh=qFJb3QTz/3jg/L6x2lbG2psgJfjIQh5q1KW1+nPPaBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N2QBXwAFfQCDt6nUR3Ttqhr7ijuK5cGdly/j3K4fQW/6RRwyBiAnoYqYuWEAhKAiKkRliXe96mHZ+lK1CcK1DX58hdaje+gbZHjJPNRQMke/rdL8pEuVpCwelRISK7PJkR8VV1buPzcJuqJWgW2/aE3+ijQmRhM68GUbQW0zXzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YM/vBNLf; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YM/vBNLf"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4aed12cea3so892271566b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 03 Nov 2025 15:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762211086; x=1762815886; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZH0fDpUKrbZ7Y4RH7y1khfYrGo0F4yDKdY+imctMyp4=;
        b=YM/vBNLfGZhALocJlfoM6aqdmbn5u8aYcjTXacwZOFqpL3l5z8OuzQs6K2rZ842TQq
         JDUFj37ukjeLXKuhviMAaY+wo1sBiAhilUnarZzwRPT0jgmXXWP8ZMmsSwdqGyzz6RnZ
         yxZ7p0axNYKHN/OuxGRYqE0I0tFcS69gd7FaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762211086; x=1762815886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZH0fDpUKrbZ7Y4RH7y1khfYrGo0F4yDKdY+imctMyp4=;
        b=McCqHYy9tv5/6PXXltjrUE5khZVsCwWe8UydsQoo7krlKBoI7ORys8SrPTXHAylzWN
         rPPstPt4nIfiREqMxIWgcfWZWaZoRyQU5tyQscYl4yNBHpxZkoykv9fGiZFxfp7DK4tF
         sZ3uDXBwxcb06kuax3EVPO17MZncYCa3FicgTRam+DIgj37at6vMb8BZvoF/8J4dJmcT
         Bqa0KGHq/QqarQvG+3iPbZ4OTOJaIOA5MFWctE2VhJxMLs8zNhxOShYyGBAGFmIfNkg7
         dkZ4dT1qg6elBimDrYgr+5xjiahkwJunIQwh6d+gErxe4SBuKad4rOL6oLSCrqKDovIu
         awow==
X-Forwarded-Encrypted: i=1; AJvYcCUQ6VwtJ4Y/LFFRi7e9fR69BAo8OWkLHcvOBfECcb5DqrL3eyQ23Row0PaKPDoUroEHSfhRZen6Y+GomCFh@vger.kernel.org
X-Gm-Message-State: AOJu0YwBN+no4eNsvd9SV4EG5zb5AYFybN7uKHHkzmHOCNYD1Cwstdz4
	GcSpgehaNRRodow8CixMaLran0vRjsW/vf+ZdfoncWkU+iXqpt8tORUASBU5coTG5QtczST2S/C
	phnHIoQOulA==
X-Gm-Gg: ASbGnctxVDzyBBAlv1NZX3C5wHw2hjBIQgONL5bnfyEojEJUWWWJyXa/mqwqlJBxbNi
	r/x5QWDYlIj9YVz/FsOc4hfSwPiz1ghqX3tfZoq1k5ple0vH15fytbi3ZBApmQo3ZCqZv1lGQsZ
	dlQyKmTDjni+GaLCD1UMf4L9KSel0VKtvn6io6vrgi4MuCBWwswe/2EMKVt/BxHrN0E51V1RAGv
	nmDv8e+9XgyTge99AjCentUb5bAYi13k7YtmFAfMU/FuQzBV08HSL39B2tdlmK4VZCkiwhumP9i
	DAFaPW86s4ZjODdk4Ngy++zrrFOK0Dhljpb5UY8zZsUl6EA5jsE23Ko7vf8G7I360xv/TRjeDLr
	XWhIWL024xspMuBHrX6abojHwed2B6k0sYWSXWrMgFHiGvE2HG3lmK3qE6ZKVGNBv4PKcIHhgFE
	g3SexHNn98Yxcz3RYwqZYOgA1OoqQQuxQQiBJQn3Y9UkKwHRpxeJA9uRwh1ArX
X-Google-Smtp-Source: AGHT+IGEJi0ag2eTheq2wzRHSlIu0uTaydwaNwD30Tak8BZ5sxNNE8iJH0d51DverPsuPGzkGFZQNg==
X-Received: by 2002:a17:907:7283:b0:b6d:505e:3da1 with SMTP id a640c23a62f3a-b70700d299amr1537230366b.7.1762211086173;
        Mon, 03 Nov 2025 15:04:46 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fa038f1sm30155666b.55.2025.11.03.15.04.44
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 15:04:44 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so8411518a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 03 Nov 2025 15:04:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVq+Yo5zo0bD5CJm9LA4xAld/CCZ93pzg0rquxf+cJCLRY8K4QlL8ejyN6yDjzpRBzLbj2LOURXKsgO0nvy@vger.kernel.org
X-Received: by 2002:a17:907:1c28:b0:b71:854:4e49 with SMTP id
 a640c23a62f3a-b710854688emr499540366b.56.1762211084280; Mon, 03 Nov 2025
 15:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org> <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org>
In-Reply-To: <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Nov 2025 08:04:28 +0900
X-Gmail-Original-Message-ID: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
X-Gm-Features: AWmQ_bmQaBgs1Hs2Yx75LVx_L0plRwfdpBhmjm5wyWf-G7aoJOGX7gmwXWEf8f8
Message-ID: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
Subject: Re: [PATCH 14/16] act: use credential guards in acct_write_process()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	cgroups@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 20:27, Christian Brauner <brauner@kernel.org> wrote:
>
>         /* Perform file operations on behalf of whoever enabled accounting */
> -       cred = override_creds(file->f_cred);
> -
> +       with_creds(file->f_cred);

I'd almost prefer if we *only* did "scoped_with_creds()" and didn't
have this version at all.

Most of the cases want that anyway, and the couple of plain
"with_creds()" cases look like they would only be cleaned up by making
the cred scoping more explicit.

What do you think?

Anyway, I approve of the whole series, obviously, I just suspect we
could narrow down the new interface a bit more.

                Linus
