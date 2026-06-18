Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6A74D8CE
	for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2026 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781809933; cv=pass; b=Eb+rFAdTFbAWlQUQ7lYABYSlRveSSm6dpVNNdUWD+Z8u0k53ahKhGgHAbOJukbdBmResX2gu6fh4GWB1kldLyjgsvakC3ysqUKNaQQXUhYiIv7NP2FOtCpzodWWJ+lll9q9Akt4FeEh9NfFUlDoZ2KKCFDyBWR/59pJbroblkqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781809933; c=relaxed/simple;
	bh=3Fmx1/NWlSdlrVWsmjsg3GX+6zUKFn7I4SilO4AgsLk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FPiDhD4WbotqB2VlEfimV4F70s8XThvdLHOGCBSs2k24LcQEPOmvP0lnm+K8ZxgH/bCHVr4rIWOaBrTjaXq+yKl3+ul3fXQ3PZGFtPd/+aTLRrZ/cWrttp6YbrsXCYKGOHVyVydRRMmg6Zap46DxMT1YT2Wv1Ur+HaxOT4KOE6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mI8BtY7E; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mI8BtY7E"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69574a26071so2438877a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2026 12:12:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781809931; cv=none;
        d=google.com; s=arc-20240605;
        b=OcunkXL8LFJVXEpY/Qsw6HeTz4gp9q+5zsM8G6eOSaHGMtJPEL8K3v8nFCFehwGhGj
         R8I+Yjxrr0YAHtSRRmzDXUGXMsVnsnrKWDCK6xUZSXurKSP8EE2Dxy3IxSpgqP0H3Ekq
         Y/xIfHG0D5as7/1Pa4XKT6cxzEBc4n5BGpakKNfeTyrDVUEquqwGB62EXnfdjzlRWw+b
         si5vqventQWiPI++CruY6GwWO11/6p6TLB2nqMbXVRb/SFn8OypCxkHaOzc00L/++nor
         ui3gn2v33gSphbOHsI8Lmy1cAVFuVq5Wk9Tx5qHuz4OZPl03gtXHN0nBLb4OEJ1HOs+s
         k9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=3Fmx1/NWlSdlrVWsmjsg3GX+6zUKFn7I4SilO4AgsLk=;
        fh=trbFwK/vGoAkLmz/Kr/+W1maMABmFnBeflYxIcgJu7s=;
        b=S5KomBzQesPqTlwPhf3AaK3Xe0uxmWGkCnbUUabPdLZU+Dz8k8ZxEFDBh6OelcVQcy
         o+hzwsEazZ+B/4NR33mio5rDM6V2aIvqfkmY5ijgfpIOjnu6X3tLzdgbL/FMni+kT90E
         NfIcO2FxPNgI16tejQrEOrxIja4WP79TUkwHFWF6kUUzFj+g9xPf+gbi0n2x2pDLsl8T
         wGmt4U6DO69ryRoyFtSn4aPsmTk+f9KggiwZeFNwCEcC8ZZnWvQIaPoh0XZDK+vVeVzu
         /6riVQD3zAIBB8de5WiyDb5kUZ4Zo9865a3rbzyGziVzUr9/KP5+wfiatbRJFtfOnbGk
         rsUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781809931; x=1782414731; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3Fmx1/NWlSdlrVWsmjsg3GX+6zUKFn7I4SilO4AgsLk=;
        b=mI8BtY7EepW9SeYIV0HqscWjYB3vlk3QYH41vuC81W+E7dhDLWyXH39Y8TxppGIsbI
         3Dto4t+5A1j5/XJvwxrZNFVEYq6OzmqzSDqiQpnXL1QRFhOHA/YrkpCej/TxKkoM8hZO
         UkP+XtMC1gYdNf7gSvKWqxozYT5NxPH+WsdsKRmLd7HOO7/VVdNooUcm1osn+ronyqEM
         ynLWo8YbXduT130VAEPVvJzgo9uQ/m40OMPBKNsH+cxqQKOITqtIMp8qIVFGL7tn2hDM
         sDD+b8ECT+o/5v8JJHvPgTGXd4Sxd+4TkOglNZ9sAyIT2yqKh4YWDMg/CMQTsBNnoLEG
         wj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781809931; x=1782414731;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Fmx1/NWlSdlrVWsmjsg3GX+6zUKFn7I4SilO4AgsLk=;
        b=oyGXpyRoDi//SfsXnDCURPJR0SzGW4q5wcr15GLWlvXhcEL1iIc61rJvIrmFZBf5qH
         IYuqQ6ib4mL8zLqW1p+IV29yU7g95DuKVLqooep8ke/Y9ZviOY2KyM8pQ7U0h38gQNbN
         dhabYgAM7o5xJWFDp+GAj61VPucXTicDqZo7ZBFT2A9oEy0PzUkh/d29eSDZeskgEuFY
         cbO5yIsxWLzNrY3jzbALt/XPjeCFq62ZPEUskQwcuk9XbC9K9LsdXe9c+k6Fa+9m75Wu
         Oa9jxyPolwEOXqOFhnNe5I4OPrqJGQ5p+OWPcdXwpdj5Cu4Nw9s4hhVh0lKHYipe5KZt
         Sj6A==
X-Forwarded-Encrypted: i=1; AFNElJ/BkL1KsaKzijhqqL0AAFzGhdt0TXENH4bvw+x9EXp0CNuuEJQ+2kBWriwLnoPo6t3Y1E+7TzsJs27RcOUh@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1My+TNabI/2YBimlMqfq3RONto///pQpE4yup6tunroebvfRm
	94v3aVvZhhdAs3KTZlsykcpftKed6eM5PZIKAIapO9t+0bSGSoLYFgk/SPowPeg1fPXpVNd/b70
	hgqFM/FdgBQ7L0nRZI3IpPbynqx7wVkc=
X-Gm-Gg: AfdE7cnqRE+QzGycGdUr4TOO7ZMTfmnfUWrilAvwO+aNjTDEwIPXBPgLa16wf8WVYrK
	OsUG7n6fPFUwYlg3M8ya/Nfmucy5m+R4CzfnN4CQbrl/KYVuiHr2Q+cMpEIcHfLyS26n9102MvA
	UnM5YqNNpysKb4ew6btnvGCzJTV02729rB8SzqVdempqGdwglX3DcyvGo5651J3WKJfp03uKCi6
	bYuPqlfuOHIjvgvjGa5Zz7QmEKn5zceLjii2hIKQgtNrqkqQGBVN5Ow40c2o2WDGMBsDyj8GrXr
	/SqKran9Q2B3Ye1kXUJvg952nDnMmgA=
X-Received: by 2002:a05:6402:3205:b0:696:c770:cd14 with SMTP id
 4fb4d7f45d1cf-69711dffeb0mr348705a12.27.1781809930364; Thu, 18 Jun 2026
 12:12:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Jun 2026 21:11:59 +0200
X-Gm-Features: AVVi8CeQslpxCSdpgRa4gpirrcupCG9eJ2LgJ1z3Ch-ANwgwQC4HgTz-290fuHA
Message-ID: <CAOQ4uxiJjVvrAwB4kcSsKsjgjtDyfy-1zDS=sMMt5Ke0ZQRSHA@mail.gmail.com>
Subject: Sashiko reviews for overlayfs
To: sashiko@lists.linux.dev
Cc: Roman Gushchin <roman.gushchin@linux.dev>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Sashiko,

Please review patches sent to
linux-unionfs@vger.kernel.org

Thanks,
Amir.
