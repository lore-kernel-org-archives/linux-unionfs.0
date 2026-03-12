Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A51A2BEFFD
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Mar 2026 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359651; cv=none; b=FcKi5B2z3RmaTzhkddU20PpPbI3X+8gX9LIjCdbVs0rWmAqFnRm7Ar+KEp8DvzL+VKhAmlPqz34p8zF0MZAVCOPgS9jenYViGbtYOXgqS0DZrGkG1jFxRPzeyTA+KhtywxL2eJdjTMa7CSq1fD7wc00vD+vskq5//bd05xJRjCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359651; c=relaxed/simple;
	bh=wOUC16WI4/reo5GvoZO5ESmt8rfD7PE3++Xf9novjKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FoX/aaUD5/A+24NkHSfIdnSCcEAg70ooFjY8sQCHtKB8o/cPYNSdI6+rze7hKYNXWr7N9FD3DMMiZk2KMZwUhfQ7C7CX1X5XVNQaQsdYpbFBYt/Uz3dHP4L+6BjI4H1EuwoZSkz/5FpuZhSaOm19ODMlhjDV+S0z+epwIu3HCj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KugMCu1d; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KugMCu1d"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-662a1855af2so2635885a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Mar 2026 16:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359648; x=1773964448; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=KugMCu1dysVO9yLaQ7LtVxpv+2zxhqnPkB690d+v50hkYrd9deqbIhi3ak4XXbf8d5
         GM58qYyLn81XRJbJ8RIwOgUOvuhrktulSxyiQhFA+K1JdktMqJNkP5GWt06pOdOdpl9c
         rNgGcWFtfO4xSHyTkKqQYSPYwQ96LmYhUuAJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359648; x=1773964448;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=fkLC8aAXlGMs5GagXLBNcvGEuJSbVK+tFymOx3jmlKs1agfoXD0yq7zPZfBZ/cg5/w
         OROfCDDccas50uFaofeTWRliPPz8z4uNrp4JzOY9j6Hl6+fc696+AqtOgOR2WtBj5fwc
         htDTCsfOq4hR/lG953ja/Fz0UgAgju8PBWum9PYbB5Gn246VRWa3WVZj4wmSQsH/IIVH
         R8HmSZCQnrSClMxEZwk9SGw4f5zjQ4RrfGg71qYjKp3MZylxiPJ+ZPY+kItoNykeCFaZ
         tHhg0S9eBWsqaMPy6YBx114qZE5pexhO4zrWZ3XXggMk6rbAWk3d9o9fEHRfWiZAOyS6
         K+cA==
X-Forwarded-Encrypted: i=1; AJvYcCWt/h/Z/psFGlkfMY9x/JKIyHpdntGo6JjyPp8fgCO7/wiiEcWCHH6EagV/db+uI/d1mlP+QmeIpgISv074@vger.kernel.org
X-Gm-Message-State: AOJu0Yza/IZACfDUHrcQfRRCY1BADLdJ/4K1xwQy49nV4VCTs98hFRMa
	yHRhb0t1ZnAYE+5Ivo+NPGq0IhGamMLmOMh1p/RQncOzb6LKyDKSDrSuRXuIZgLcFJDATOAYsnP
	sa9CLY7M=
X-Gm-Gg: ATEYQzyUn34neUeCl00enCSB0krYfalWHfgzZg5N3V/OfQWuH2d8QJImA0iPamzWyvK
	4lIuEanmt8HKIHSzMJe2S/KdgOEWzw+88/rrH5/PNRFwFhUwJy8jH7s5vFDf+LjH/rPtc+5EAt5
	FL9mENYa6vGZCbpmq82SmmWnF86yhm/p1xu89Yh8RmicL6on47/lI4F/CT3CrkfRLCgWcvNpjAR
	9MlJccaFjdY6WZcSzLGB7iNdVY0qLKIMQkcDyFbjew8kaj2+mcB4dG4pVtFxo24IpRaifcayYLn
	PaMKHMfXE7KjxFgBNlGVNrC3s7z0rDSC1eFKdFWkUfY9gmZqCIIN0dTdWQIMy+UA5XR+R0BvPIq
	Hog0pZ/EDAqp1U4ZVJMduGK+vxdDuHqiheNVnCkYLY5xuwU0TtQ6gg7U3c7YS3D9DxsWCjuQ3pk
	5OV+nVmEswhhVl7VKVDB3fl7EBSLxEQcfon8xPdEDv7TpWYINdsLArVjoWQVdGXbFOVmCzdfmY
X-Received: by 2002:a05:6402:3646:b0:659:3ed2:13fe with SMTP id 4fb4d7f45d1cf-663ba9c29c2mr499970a12.6.1773359648312;
        Thu, 12 Mar 2026 16:54:08 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6635088fa23sm846744a12.16.2026.03.12.16.54.07
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:54:07 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b976e181895so2813666b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Mar 2026 16:54:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVt4VlLbvWnnEAZionjIy8Suk9QA5hBglSCjqyat6Mhmr2XAGOBlY8al6OxnPS/Nmx6Cqj7s7JPt2J1X+J3@vger.kernel.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus
