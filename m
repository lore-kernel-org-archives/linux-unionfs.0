Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0F7EEFD
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 06:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732342166; cv=none; b=V5NNG9j1vxEOIq9fjQ510YW4qC+zyL2p5YfciPtk03HYsSZNPyhYkI4PuOnlI53JRFK5b1bFJ7wA+YiqSlLvtdMqD4YyVcMlOGcmcgk4mT0dHVre3Z5XT50salKd7PqrE6h7BQS/GhZIuAvB7z8YjvFb/mYPuFzfxOyg3yy3Eys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732342166; c=relaxed/simple;
	bh=MGyPtryu9vwlqXgH+YK8PKy2Yv9hW/j3LeOUBVe2VI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5RjDWAMd0HiAZaHHjE06apKAteV7gmGwgweJpasDnR9q/I9UMw2likNIJxhV3BAYXmYFi39rB0YOIA+iNmn+/JfyzEHjaku23lmb93eBd0wbAxu9sJSsAP+z8fDi1uP7QCRbV91CfPaJ3wKWWz0i+cd5jFROMHV2xoIbua9xoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IsMpb+GE; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IsMpb+GE"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aadb1so3670989a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 22:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732342163; x=1732946963; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IbrjbqNKCRo+IWqsypSqGBrpKrn9jqq/jrjfhjQ4XdM=;
        b=IsMpb+GE9S3EQuX4OjSBqeBU90BXVpMVwWDTZl0XII9fZCcpOcf/YZFXXE/8/8YUNQ
         xjpdzoY4ZV1Z+xrY20Pptm5nahgfk675MeVLddykasp9S+5P9PjyBXa5ATgQ3rcaTSlc
         NSYtPj8i1cxyBwPD8p+5HSpy2iA2q8lhofdOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732342163; x=1732946963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbrjbqNKCRo+IWqsypSqGBrpKrn9jqq/jrjfhjQ4XdM=;
        b=BzVuLf7q64ZbKM4y+OX1q/oWRYhRo9gtzJmJAs0GSlqccsy03xDW5lehSNmRT9M6vE
         uVDA5h62fJjcCEbSmSuDUlkiig2dW064TbkX9Vw/ReBhMyBzLEw7ZpzpTQxsNCVqRBXf
         ZQdLysgZvNy9jOUgj4WFS5E8fz75c+HoTqgLvCyOBoPGvBxGFRWrX6vA20FBNg0YrGZm
         fHm4Ll1jiYczFdGimQtjETgQvwfBt1NTwjqohqWcpZU5D2MOFlsOtFVTdbshXm6E7esW
         GXrbqHg8QHTuHJ5yytyd9kkfkGqUyOw8x/ecNhdByQ7gaw9VbCmTdMP1gcqhxB8UHwOg
         zgWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtwbVtRBJUwD0r16e4pt1JnfpLmhUrwsAx6HlmE+oD81+SHt607/3dLw2wp2SSjsJ5xH4rtgSYBDjiTfd2@vger.kernel.org
X-Gm-Message-State: AOJu0YypRgqDoDERfe6dEnssnp1b27cRG3bZnWeYaHXZVMzskI54RTzo
	bPbyuYAlDrI/QIRN3LR1UobE03FABtS4838mf1jWimRxDsSjji510wGKZNlwWAOI9VdYKhyY1U0
	01C3byA==
X-Gm-Gg: ASbGncuG/Cfea/WOMgKBgE6lsJ+G2YGiR/BHJAlYVMxtc+gG6nd9POP5VZEcx215AZF
	taITfJPsDuGniz7IywQruzIzJFGHGztJiphpjmoQPbURwzCnY3Myox9xo0FZmxyHd113NuBLCbs
	DTUZ2+QH9UK7+jj4ODLZkrkvgzxNEqZvLy40TOnJddZQ558ZMt2JO4ny+w/slOrNgig0Id2XwNB
	9oF6yU5oDZn+aj3BzZNBF9aeb1F00Jd5Xo101z1gcuoXJzUz7bgrz0CMCwKecN3XLSe15DslSw6
	L0pNs4dAVRkCqfoNMFB+rQlv
X-Google-Smtp-Source: AGHT+IHuVmqNj2TfyOS7u+7iggW6IMPMUGc7WXZhgnWZ8E5PFc/qRkbsbBJFjcb4dx837YVfejVXmg==
X-Received: by 2002:a05:6402:3509:b0:5cf:1b53:1bf4 with SMTP id 4fb4d7f45d1cf-5d020626645mr3940913a12.17.1732342163026;
        Fri, 22 Nov 2024 22:09:23 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b5c621dsm180349866b.205.2024.11.22.22.09.21
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 22:09:22 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa5366d3b47so19181066b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 22:09:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW52oT5Vr2faSr1klL4ZdMQBOGeafTR3uPnoIgJ7X2tXlkACPEsccqOxQQah7wE5Un4QkwSnfKl1jqT8N8m@vger.kernel.org
X-Received: by 2002:a17:906:32d1:b0:a99:cedd:4612 with SMTP id
 a640c23a62f3a-aa50997e1fdmr440623366b.22.1732342160869; Fri, 22 Nov 2024
 22:09:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122095746.198762-1-amir73il@gmail.com> <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
In-Reply-To: <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Nov 2024 22:09:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLSHFvUhf7J5aJuuWpkW7vayoHjmtbnY1HZZvT361uxA@mail.gmail.com>
Message-ID: <CAHk-=wgLSHFvUhf7J5aJuuWpkW7vayoHjmtbnY1HZZvT361uxA@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs updates for 6.13
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 21:21, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So may I ask that you look at perhaps just converting the (not very
> many) users of the non-light cred override to the "light" version?

I think you could do a completely automated conversion:

 (a) add a new "dup_cred()" helper

    /* Get the cred without clearing the 'non_rcu' flag */
    const struct cred *dup_cred(const struct cred *cred)
    { get_new_cred((struct cred *)cred); return cred; }

 (b) mindlessly convert:

    override_creds(cred) -> override_creds_light(dup_cred(cred))

    revert_creds(cred) -> put_cred(revert_creds_light(old));

 (c) rename away the "_light" again:

    override_creds_light -> override_creds
    revert_creds_light -> revert_creds

and then finally the only non-automated part would be

 (d) simplify any obvious and trivial dup_cred -> put_cred chains.

which might take some effort, but there should be at least a couple of
really obvious cases of "that's not necessary".

Because honestly, I think I'd rather see a few cases of

        old_creds = override_creds(dup_cred(cred));
        ...
        put_cred(revert_creds(old));

that look a bit more complicated, and couldn't be trivially simplified away.

That seems better than the current case of having two very different
forms of override_creds() / put_cred() where people have to know
deeply when to use one or the other.

No?

                Linus
