Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9F3224
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Jul 2024 08:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721117979; cv=none; b=Q7GjzwQcF1lCfbbyBWtDj80tp5jAdmCTne9ZcijcgpzGud2mShfu8oqeMlScDEv7m3/JiM9B4bZvjB2IbJm1L15TSC8PLUB9RnPeblKM51eGK793hmrmqNejGnnkN6P2PP9jMtKu2YIv7IXuJNRd0Dj+UtW1DZ1h47+TIyUqS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721117979; c=relaxed/simple;
	bh=vXoToTG5cjMxkFNErtpXLKT6xtj6oDJivP28rzWjkik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R6RloPw6xaeAKl1tccUcwHGazp7iFp33JCe3thbUDjnP4gSovQT3Zf6GxmBmH/2d2En7EWytK8dPUxTIgc1Bgr/UbEnFtaG49kYd1rKSTwJsakiDGqzAbCh4i43cuRDsn/bBqe4kbWjVsbSKBFsmZ2JI6lGgMREl5lX+V3vhfyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQ/ytTw1; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQ/ytTw1"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-79f17d6be18so326427085a.2
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Jul 2024 01:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721117976; x=1721722776; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vXoToTG5cjMxkFNErtpXLKT6xtj6oDJivP28rzWjkik=;
        b=aQ/ytTw1YvzMyEG90KLmQZXuKCNAbcyjVgwkL/F7FywKpg0zrGWth7UgVhZ5nA9k+e
         EDN6yGcYFh+pwDJ/PGOAPtT/RIHTvlbeVOg/A/REdmtHSJhrnxTlPYZJORvLrfU1NpLz
         yWgRwY0Ztr3NKQdD+Naq3RoH1UHaUe2Swy0lKzjMtXzXqb57DPBFyaqfxgQl4wTVqWkR
         xGTJJ7coU1Eyl2qErVYYr/0/T+9H4KTXr6/nbopG7AnmtW9vb8GWRZkwSbyQrAKM1BQV
         rYDuXF9QHnguFW3uDIc0Q3ni1X0DiRsDG5gr4iyIp7MWEWwJQved0SeOcyJaAAF9DdFs
         eaPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721117976; x=1721722776;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXoToTG5cjMxkFNErtpXLKT6xtj6oDJivP28rzWjkik=;
        b=vcT5yCJIjd9g0soxdnPmad+pyyGRNnpl0BWz2/haU8QDSi4o5mEeFyjK68cFPLvWYR
         NCaptvhorEGi19T9Oovc88ORIW8xk6oEF97PjaI/Mm73QvkoQaz6oK8M8wprVqJixj10
         UHm3uQpHilA8usEANCQLg8g0mO4bsdUkiaYH871tjjH8erbQT0sh0PxjPQ/0CiSStl3d
         DewDdB/4xoDGgb3UvIU9tm3dO54nbU5pY8Qszcj/H4YQ4aCxtjCYWYRF6JnNarKOT1GA
         1b7Udd1ytOOnhMk5/esA5wGEsLx8mvKkvEsemRdtldBdDkoDlVR8A7sjmhkjOyhzJfgH
         DmEA==
X-Forwarded-Encrypted: i=1; AJvYcCWgEPMy0P+xb/XfTx+kdZ5dihGOCe03QN9U3oTE+rilnqPuU7UgtzCe8suc0OcyRTHXbj1l7I4H8C93My7PUr51grhroxVVN2WzcCpqiw==
X-Gm-Message-State: AOJu0YyODFdwWEtPNjtj1CkG4L27mi3riB8kpyGb16wgED65Pfy/UcsM
	xc1+ALs/STsMvjRfL8IKM92jQ9zgom0Mqs5mbF4C0zNRrG2QFj59cWA1bvHu3v4lN0mJ8NZ8Awg
	69BS3whEF4d6xXTUplMQzc2SevF9F7eXfaWA=
X-Google-Smtp-Source: AGHT+IEoI45zvnff/+MZY6qWrg6qJG8HmYBZAsmVFzCxbKcQlL4jXghZvoX/8160Idq8lotWsnjFh5CEsBDQcX7XHP8=
X-Received: by 2002:a05:620a:28ca:b0:79d:76c3:5300 with SMTP id
 af79cd13be357-7a17b69d44dmr146854185a.15.1721117976320; Tue, 16 Jul 2024
 01:19:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a2391c78f3974c5d92aa53574bde4eca@exch01.asrmicro.com>
 <CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com>
 <d75ce286091046438f8828554eb3f781@exch01.asrmicro.com> <CAOQ4uxhJET3v7+7+Cw-wnsRbpPa6ufRDFYaGYWD9RYLgfUxRZA@mail.gmail.com>
 <47d8bf2202a943e5967454499ee61248@exch01.asrmicro.com>
In-Reply-To: <47d8bf2202a943e5967454499ee61248@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 16 Jul 2024 11:19:25 +0300
Message-ID: <CAOQ4uxgPSrjA20EAHeoGxjtE7odO6t1V1O4abOwUW8J2rTDBOw@mail.gmail.com>
Subject: Re: overlayfs issue: dir permission lost during overlayfs copy-up
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> And for version 5.4.276, I need to add fsync at the end of ovl_copy_up_inode (correspond to latest function ovl_copy_up_metadata), right?
>

Sounds right, but I do not have time to examine out-of-tree backport effort.
First, you need to provide a working and tested patch for upstream.
If that gets accepted, we can discuss backporting efforts.
But the general idea is this:
ovl_do_rename() serves as the "atomic" copy up operation
everything that happens before that will not be observed after crash
if rename did not happen.

The problem is that inode metadata changes that happened before rename
are NOT guaranteed by POSIX to be observed after crash even by rename
is observe unless fsync() is called on the source inode before rename.

Thanks,
Amir.
