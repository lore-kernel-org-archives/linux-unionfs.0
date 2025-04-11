Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B43293B4B
	for <linux-unionfs@vger.kernel.org>; Fri, 11 Apr 2025 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360102; cv=none; b=Dh9VAV6pUjn7ItZ0vY4pnWRWuXjcRpIFoIC8jmxJrDFu2IqXcUpss71X+TdwKvR/HS9q7+TX2HHI1q0V5/3xfEfnOcrjPSRIcIk1dEqf40BDj8zt7tG1UchidAVlXlzyyRiF4h1rh8FZ2j6YjNp7qvZbpBaj/YxrvdMvzRuJNxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360102; c=relaxed/simple;
	bh=O/EfSIW4cWyPb2rH3Ro6WEJgCUswl+SOg2WxCdC+5ko=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=K/eGUtmYc2gBLPxGfq7GsinJhabAcRB9yWOcfqrLG306J05Opy3TpYT2B1n6UUGisBVY1i2jtLs7f9ptQiAP355cxPIk7hWS65KrXY7USoe/Lw3TO1FamBzhqtFQKiS5inMqDMwJ7Hy9VZuHPCcZ6WtWvuy9kVUZA8lSA2H9j8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=K5krdYlC; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="K5krdYlC"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-47692b9d059so23204801cf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Apr 2025 01:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1744360097; x=1744964897; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YkSKxy7ZFlAbtEgT7iRPpwlnC+b+4x8tjORrxdlKnQM=;
        b=K5krdYlCXroQngcYWDMXGmcLWGzT+Q/f246iPp0fxy0wp7U+QVLU0GTj1J4/srP6EN
         FTJbF/PGgdzuwF42BpnvgdvrhNfgS/zqRJsLfV5ifF9jlpEN8uiUB3AL++xmNPT6qaUg
         xOm9QKvIHOefRqyeOKZI7cKx6zvSpNbVb96oA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744360097; x=1744964897;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YkSKxy7ZFlAbtEgT7iRPpwlnC+b+4x8tjORrxdlKnQM=;
        b=XMbWxlWYbyLmcfDyqBKf3CWVqpD65ZhNZsMmOJ1tTdWuBr8/TW7A4dMzeP1swDVEfl
         /UEncOdx1alDgQKQaZe/l8/Cdmdb9eB28n6wU4ZjKHKzHskIm2/Lb+LIYiYUjFSd3d5k
         Sq3DCpQmqGjEvUclbY48y7y4hD9+s6qjV4IrhL5MeoEBe3x8mJms+Vb2RtiCSWFtuipQ
         yMcNEss5P9/XLkjPqs8q+gXCOWP3I67dsMZHRt+St50M7As2lVWumMmWnzGdKdK+MFmW
         8uU3W6bxCBdg1rR0A1cb7DN5besxi6fcy8+YgYRe0EDVTsrOuMS/2EhTtyewKjYi0Ed7
         F+5w==
X-Gm-Message-State: AOJu0YynFWRM+9zWRZicGa93cswxFCQRvN4Kyx2r6WyslOFB63XfH3pB
	BMkq0VSMbpDWSll0J0PHclpRp1edlecopewxK7iyRc8seyvfiAgNnuf6SF1OXqal9CE1sJYZjtu
	dYyv2zIdte3YsRqxW9tjXfPu4HvUwZoy8guIkrw==
X-Gm-Gg: ASbGncvD26wxpHOkQWP/YmQuVimjo0/0jyEmVpx/D4f1X+m3+IL+q+ut63Y5CEWIXfi
	XY9dTO+48EJN5+xb528Fo2fKUEbhVdVR4149qTzFoNznHl7guK7wk0pz/S2566YlnOT6oUFyGUi
	+bShoubtJAwtLrIYdo0hzJ1Ew=
X-Google-Smtp-Source: AGHT+IEM9rU32Q2enCYeri2d252JhnrampGV8po98Cr8FmF+oICw/7ZI6ew1qqQLKEOKEIbPYY978uadq3FgBPZXjPM=
X-Received: by 2002:ac8:5893:0:b0:476:b783:aae8 with SMTP id
 d75a77b69052e-4797756ddbbmr23433771cf.26.1744360097448; Fri, 11 Apr 2025
 01:28:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 11 Apr 2025 10:28:05 +0200
X-Gm-Features: ATxdqUF59ro4iAD2MykNxWHKeOxmT8-Sc2-u9dr-ty-djEISOYR1wAZx_56W6vQ
Message-ID: <CAJfpegt-EE4RROKDXA3g5GxAYXQrWcLAL1TfTPK-=VmPC7U13g@mail.gmail.com>
Subject: [GIT PULL] overlayfs fixes for 6.15-rc2
To: Christian Brauner <brauner@kernel.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christian,

Please pull the following into your fixes branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
tags/ovl-fixes-6.15-rc2

- Fix an missing check for no lowerdir if the datadir+ option was used

- Misc cleanup.

Thanks,
Miklos

---
Giuseppe Scrivano (1):
      ovl: remove unused forward declaration

Miklos Szeredi (1):
      ovl: don't allow datadir only

---
 fs/overlayfs/overlayfs.h | 2 --
 fs/overlayfs/super.c     | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)
