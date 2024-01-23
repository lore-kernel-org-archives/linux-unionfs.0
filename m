Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7095C8E3
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 10:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006348; cv=none; b=SDmOiMu0OuIlga6CO25zMzw7z9Ff/xOVOFnPLxpgjF3MY63L0j20OsQxxMGik0L0+3Mb4Pf/T2UokZXMI+cn/wE2WCG8WyCvbstkBfrjcJ9pTKAnM2d0t+ZJ9WDfiRj6IzQuUcYLv8czZTWTmbw0aiYAsdse3dmxXTJZIQSnZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006348; c=relaxed/simple;
	bh=SHRrQLNnplcWmGubbLiQtph5qwc+y2dqHhOd4QF4o14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=btSQtwMFJ5HsEaSWmltvWYafTi0f/gaOijiGwCDcFpj8ufdCTaEAh1ybvrWDWhDhB3Zn8Ssxe7R4nGjAxjvgA4Gu/q8a3yZHWy249tfqVcjCKMiiDSUrGIrOqXATqcntENPylDoF903ZHhQ4oujBTOW8O2ZRCMuIKzyP6kbwfH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYTlhhga; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYTlhhga"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4b7fc7642fcso837866e0c.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 02:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706006346; x=1706611146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raBGFnaCpigBb2guyCJioVhCG8XEe11RJDbY7013kHI=;
        b=iYTlhhga4M5SP1l0oGZgamBIfOWssuRaj7yHVk0OBtxKHx65ZOFHaypXfjlrvGu5Wk
         VTRfYYGg/oa1fB/SLATcyBKIJW4giK0thGjpoznQok1gfyCoS76VJT+eLWXl8v+pyoA+
         Wgkt3x/w8hIQsr9OLhAZDHu9fPl2215IuM7rTDCC+GsjHpVP3M0Ua/lJ8WkxgWGU/YjM
         aJ6P1cV0SmEh+B3RFEuPYT4KO11vbiVUxJB3udCO0GrVt/CLxIC/FCN+L4d2s2FWTBGw
         vaukaTzOYKTE0cR9SlPS0hHeJlgmFbbZuZ2qWagIVJ6VBC0EPemDQLfJI+xqcptx7xDT
         ra1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706006346; x=1706611146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=raBGFnaCpigBb2guyCJioVhCG8XEe11RJDbY7013kHI=;
        b=vLQt7F2QFjl2ATDaAkSqwDpi/0nIUgfJJfKDM6TQadUQrTT0YX4szH76/xpHL88x1I
         5N6vEBlwAF5fFBYtyeRqiv4ZhUSdGN16R8XH4wtdkg+YIAPkGgygxHZQUXuxMlmPTIZ5
         abIvOzP9U95PmpR3DYJ1ClQ9lkd8KnVZtlaYRMEt7aFI8ifZO3z5y/B+oXIl/hllKbIl
         fBsStyXTOxUEQlb1DQtsz+IPpA5V1pAIvwYiFsx1S+cYNjPBbweybMm5N8o40UGWvDL0
         lLG6GYd630RuoS3cBKlmztFgmgjsICUfFlFrGy72zGqbu3Xh4WfRZ7JN7CTf3Oqdkb1n
         irTw==
X-Gm-Message-State: AOJu0YyEarnbs+NUGyNlrHsPBF0YfLfRECvAaKECZ3UX4Vzl3s6OAq7K
	oE864PSMOy6vkItybOnHR/wMyP5Oahmmz7svUjqSDrvCrwLPG+7X4dA0NgO1nfMu7QY9Y26hG7i
	zOdHNl9o1POXODBM3Pd2WBpF3TeBH3/d3q+DIoA==
X-Google-Smtp-Source: AGHT+IFXSowVOkd0dJnTOmw0Zp6YQtkLs8tpYwh98uscokQyTaLbtiI+sQbl0+JO1kjEZCSlzwn7tzgVzqxG2RLauEE=
X-Received: by 2002:a05:6122:180c:b0:4b7:3141:ff8a with SMTP id
 ay12-20020a056122180c00b004b73141ff8amr2199540vkb.32.1706006346147; Tue, 23
 Jan 2024 02:39:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122195100.452360-1-amir73il@gmail.com> <CAJfpegtbM_tGH0OfmP08qrVPp5iDDJBeppAwsCb_m=+kS7Hbpg@mail.gmail.com>
In-Reply-To: <CAJfpegtbM_tGH0OfmP08qrVPp5iDDJBeppAwsCb_m=+kS7Hbpg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jan 2024 12:38:46 +0200
Message-ID: <CAOQ4uxgOt1E-S2gJaHPLvTaZNa0jr8HMLX8ruhced2aWxcyO7A@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 11:54=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Mon, 22 Jan 2024 at 20:51, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > +void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
> > +                             const struct ovl_layer *layer)
> > +{
> > +       if (layer->has_xwhiteouts)
> > +               return;
> > +
> > +       /* Write once to read-mostly layer properties */
> > +       ((struct ovl_layer *)layer)->has_xwhiteouts =3D true;
>
> The cast is wrong.  After this change *ofs->layers is no longer const,
> so it should not be marked as such.
>

Yap, I was considering this:

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b26d1824bf87..cb449ab310a7 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -61,7 +61,7 @@ struct ovl_fs {
        unsigned int numfs;
        /* Number of data-only lower layers */
        unsigned int numdatalayer;
-       const struct ovl_layer *layers;
+       struct ovl_layer *layers;
        struct ovl_sb *fs;
        /* workbasedir is the path at workdir=3D mount option */
        struct dentry *workbasedir;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0551ba4e3e6a..a8e17f14d7a2 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -485,7 +485,7 @@ void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
                return;

        /* Write once to read-mostly layer properties */
-       ((struct ovl_layer *)layer)->has_xwhiteouts =3D true;
+       ofs->layers[layer->idx].has_xwhiteouts =3D true;
 }

--

It's still a bit ugly that @layer argument to this function is const,
but the first likely check is really const and I do not want to make
ovl_path::layer non-const.

Do you agree with the above change?

Thanks,
Amir.
