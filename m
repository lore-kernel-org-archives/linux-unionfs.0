Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9B03AC0F8
	for <linux-unionfs@vger.kernel.org>; Wed, 29 Apr 2026 21:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496960; cv=none; b=d5lWNM9kpBQ8jttIC6tKXHbOygKnwsHy4HyuOYdbNkwMqcPJ5Y+GKAUByqU0D7QKl5kR9u8xmyBMsvwruKtChjIua3GyiKdWFax2rApBr7babN9RSKjmf8rg6q0R+0SNFGSIoNNELIG9siFCyXmN4f0DzTyJd0Y3CvYmLuvUcCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496960; c=relaxed/simple;
	bh=tKD1kZoqphx/1IqZo+FxuGf68uivswEb8Ml+8Wv6abw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ORnpRWdZ1OWs4VGi2PoxUex3VlH2Ln9BSm6iTpud8dYs/L7Fk0kbCxHzdD8Ec8M+y1yMDLe3rLa6W9TltIKYia4aqXd9YWnXp/AuBQ+tBThCz66BGd3gHOoVpzpNg+rappLX9/ozL2T5HYZfgNvUpe2mdCs0CVhakjbr5SnN6eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AEF87eG1; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AEF87eG1"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ba8472c1613so34237066b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Apr 2026 14:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777496957; x=1778101757; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HnqVnLYxhZQkXEJ+qyCw2Y174F/Hy99oiICnSXcEeRc=;
        b=AEF87eG10q/L8bjxMLWgsKvK06PQmL5YaztirwoHi/TD/ejuHIzl9SnQlEE2jZuHnR
         PTJAEKBmz0eFUlcilkcmYSuDuVVKQO68f/ysU3Tqroam/oZ8/1dolCiFZwCcvL8xMrYa
         kIIcienwZpy9P3FfB3iOuqiQS0vaTK9GfFNNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777496957; x=1778101757;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnqVnLYxhZQkXEJ+qyCw2Y174F/Hy99oiICnSXcEeRc=;
        b=NaSAUWsN3Chi1q+8NMEJD1gGBr0sSkhXtX0TsviCuVwOZvPFOs6sGIPZcZ0fjx5MGX
         COthyqiv1y0eC6tAaCAnDVd8uuQO70wEydtckz3DZRB3vvXT+uw3Q+RGa6FvtBBxagER
         fZvKax+5KtUXkODMfup+Gj4PWWsXUjzV4htsCEsoR7io8Efg+FOq045xuSiglmNzWWE+
         tRwKjmHkmjTJkdvvUowzD2yNpMCRe9y8FHS3EMJrrxKAYZzuzV7RrgblcSZLBCdPjG2l
         zC6uL5VDwhaZ7oo44Tsjqn/vB2OLcy1ZdzCOb9BvxqM0puzGn6VTzcXxzVKG+Dg2xen7
         waUA==
X-Forwarded-Encrypted: i=1; AFNElJ9PottVhwrt9PQa19VJMwv+9ZhyHktFcXt3N1ow0qYB2aIWPmDE/SPgRdxZHITHGCHCSMjiwpG3wfXzc+aq@vger.kernel.org
X-Gm-Message-State: AOJu0YwyHt30AomD2GlkPXuO3DcUqY+X1FuK8oiU/a/dVgbktimW0oXu
	w78lb4/xIQvls2rmq1JdNE9fwA13b5qqdtpiq+GbxVBZs06hJvICay4p3H8lJHNuqPQ6gb4gm2L
	zi0viThY=
X-Gm-Gg: AeBDievM9WkajWbO8TRL2uO2Wpgmesaw5c2QC0Ihe/S/IHohlUBdR9jRhSeotipoI66
	oGOwqw2wHwu5GwEJ9psQ3izh3kve/pv+RSlHB3NNdbND94v2glmD+z9sDDq5wjWHWZs8CPJp3G9
	B8fFte5FdEpEBjbr9rOBezTRWFkI+GJQxS+9BMWV1x6hofznjEgydiYnmB6Ok7e7YABSmGlSqNN
	bMrtugru+RC03v8uPYJ/z4oluKgd8amlywpP8ZyCXK/n5WzhDGclgrsNxHCteY/X6HFV8RGDUoU
	Uiww6ysCshIfVBaWzd4AcMi1dYW1GqkTQhR1pnID6VfmxNxE7p3iVR2ZYRVfG6lBngo25+rin4k
	GXIOi+wQd2LM4RDqpA9QXS6/wheHSCZ2SpzEuu+KsYQ+tz4BL+jZrtJZlNBJ4Fw2wXj0RZBq2IL
	DECpPuJmzR5xsQQgWmy2Smisw4qx+Zx7HpVAg5QcUe/ekEh7DfhBrksIzoatKcQxk/+E+/+AEs5
	FL9M6Hus5c=
X-Received: by 2002:a17:907:8746:b0:bae:c57e:d192 with SMTP id a640c23a62f3a-bbac74a8bfamr25784466b.41.1777496953084;
        Wed, 29 Apr 2026 14:09:13 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb980a6fe30sm134908366b.5.2026.04.29.14.09.12
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 14:09:12 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so29079766b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Apr 2026 14:09:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/S+BHgp+tGfwgkP0YxmVMiTeZLyq/Z8mRfLk/37kaJl6Sj5E7UK0X6h4MkViiJ4CZ85nfbDJ5SVvKrXigg@vger.kernel.org
X-Received: by 2002:a17:907:5cb:b0:bad:dfe1:6a56 with SMTP id
 a640c23a62f3a-bbac6ac310emr20951866b.30.1777496634502; Wed, 29 Apr 2026
 14:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-5-neilb@ownmail.net>
 <20260428033738.GV3518998@ZenIV> <177737511992.1474915.1952404144121931523@noble.neil.brown.name>
 <20260428142225.GX3518998@ZenIV> <177741881482.1474915.12527082398060370192@noble.neil.brown.name>
 <20260429052626.GY3518998@ZenIV> <20260429170731.GZ3518998@ZenIV>
In-Reply-To: <20260429170731.GZ3518998@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Apr 2026 14:03:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgs8yAfaQYmeKWab7KES0jU46TvdBfQ3Q9+6+=E=vrx=w@mail.gmail.com>
X-Gm-Features: AVHnY4JtG_9GDiz56QzrtD5BrZqKcsiFlr8t2n0kWXJmeuX800NGv4Qx6DLxhBo
Message-ID: <CAHk-=wgs8yAfaQYmeKWab7KES0jU46TvdBfQ3Q9+6+=E=vrx=w@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] VFS: use wait_var_event for waiting in d_alloc_parallel()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 Apr 2026 at 10:07, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Something like patch below (on top of -rc1, completely untested).

This looks like a clear improvement to me.

... but I obviously didn't test it either. But just looking at the
patch I went "Make it so".

             Linus
