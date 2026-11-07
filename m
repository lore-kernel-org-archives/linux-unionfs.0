Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070378;
	b=E57wWS6j8gDswLwHEPCt+NDu2hOSNfdbONuFM7l2+Y/kxqYH44RdZrNH59rvtboijixp
	 CB4eELVT1V5/bl1Z9uyhkH1+fo4yuwsjBEND3TH1J2SK+IWkczHUwTFaG8G79DKFY/3gD
	 Wxk/N/GrjH5HKq74+TmBUTgAk+PcAgr8HXFcjvGfisYbk+dG7r/yqCMQkO75Xu92fGu6h
	 3c+EqYdV5/0B/YdEW1HsAnzAhGyGmeFGP7R3qaeTUQbPFfSJQJ7Xp7/99ySv4DvkjKmXn
	 wpG/JHZ+ijzn0XAoUwkKlNiYdRFUtO+tDrHHNdPNMjD3qenkSraCWw+wu+7z9+urAhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OX53f82pg8rAzuHCIXr3W8ktDCdjNfY0YDDamqZGbzs=;
	b=28Rt+jAzjLbMVzXSE6/rLc+AiNTvB5vwn+VqdxKuva4FYyFkP56p895Pb86kP32nq+NH
	 okUJ3mOtUfqpIQNHchW27yRzRhzN6ypFkahCVwpUhP0yKTsOOICzK2lGYzdTOyeiyseE5
	 LqU2l6qtqJ1TSbYw4Gt7lxXgwJSA92Fw5lQfyZPHeDoQSEUMDQo6Ps8/Y+p1Az5ubP+kZ
	 yiodh/35gkLATixMozEnkZEDiF34eExQoaCtsn7U/dakh/7Qht67aUcUE66F7k9MaOaeY
	 NWgjUV8rrYyFPKt9SMJzmPxGwdKa2KC+DiQDF4yeCD9THX5UCVXu2kxgf5NCz4JO36w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l20rkbso;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BD5606A32F
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 16:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95BD5606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l20rkbso
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so1872137a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 08:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070377; x=1794675177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OX53f82pg8rAzuHCIXr3W8ktDCdjNfY0YDDamqZGbzs=;
        b=l20rkbso1w2CKDV3qqva9CCmi8ZfT3r/ydjSwEyT28X+YT1e5HxNbk0Lei9pLEtMOR
         1AGRqlEw80l3VG2EB20DfZPTqTqhEsickI/j2cz1mrVF0wOQ+EQL3oK2CbFW9f8wIyPJ
         OfGg5NO9x/06OsFBhKo8Z968v91WsNhlei4xq6tzglGViwwmOwSenspTgRlSxD/0w8SZ
         GXJy0CaS1QI22z29LYBUqbYCJ4XJMyilbxYisyiKvW+q4J+g3oi14o5iTdjjg02mt40O
         PGjSX0HKu966FX69A5+iobmB+2+z7Iakh9pJPHLMfaKGy8E4L/H52zyT4Ukt0G8toSr3
         UZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070377; x=1794675177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OX53f82pg8rAzuHCIXr3W8ktDCdjNfY0YDDamqZGbzs=;
        b=c2NiHOtFYlLF3S22PJ/trV/MRqLNDsiZf4F2gBiQQZKCGq0769qRKza3U4rnCy29W6
         YwoeqJGZbQW9tuk7s2WSPWrBG2nlZNTj1wAfLVUEQnWW9Creu10z9vgD3e/QgXuNLgf9
         XCXDNA6WPqn3zMtj3OJkhmvf7BD4QIh6gYY5ph4poeNFWlrqYmT5lI4GFFMaUVrXbXQG
         UECo/s1WQV2AK5/QXg6pjZLSnDCKOYksYC92kMIbdfMpPrgutY41yuMZqa5k4ZlUUAyL
         l3oPKxaS1bG9nO3qxsrc+9n8Wd1hdthIXOLpGjgiqeYgrY/4sFkbevGgCINe14XvXJXk
         UQZQ==
X-Forwarded-Encrypted: i=1; AL+hErEbKNuSBTON9SJkKevQ6uXAinKdX6TRfrsHMLui2TlIa9hSXAA1sJ7S8RmU1FZmPzQoliCnqNxPA3k+UFUI@vger.kernel.org
X-Gm-Message-State: APuU4Z/Rd6xtmbptG67OyHjoo49F/TmpiFX6Hv0yw09OYGWdsHjEYHxL
	lIvNDr35YeRrb/ler3DZabxdzGsIULvC1kyq47M0jI9+SdRSRFrofSzI
X-Gm-Gg: AYBFou1tx0r3jte33/PYRxptO50UbQ0ZUy/9E0PF3JvkbdArCYn6SXZQSYYi+j4cqNv
	ZRaVjJlydkxjgBWt20Te6j4tOulhs59u8ncYwXshUCTmQy1SRx4JjRQuWxp93HuynMJFpjRFgSl
	c+vQvp0uTq4SBkUdwLtHOCfYH8owLLJBSqRoznNvtWrvCeBJGLPQu/9SMTVRyvtH+T1jcYZzgTM
	bMOqKgQA8YgslqbI8+4vIDjFMcIM7aFbNT750JNL3jg9AkzyJy+SIkGy1ycpTxld5pcmjuhJoeS
	OG6dA7/+Iz65721z+21V661EcTeh03JKsGVxoTMXUsZsp51ZNgoPlufgyFqboQ7z6LumNpzSY2X
	U9Dl0EK8nshh1nYY5BPpjJvlTbROXLnt1yH0CITqmHOcSLIT1emxNsIUy3Na66Xas9WGeGjR6wa
	vGtr2hfwkaMEXZRu2Dk7tmCgsUEYrFz5BPFgfUqvF57FBHid8GcmSM2WsiHfpvJ0FYa9K1iVAKR
	Iqi8cFpqtr2m4qRn0kJuJu+vsB+kWEIxW6GEJ/RCf08ef5rj5Q9M4Dg0jjfJpzgEvH/cTnKzecQ
	MO8jIAPeG2comMugOxuBTKhtf01Ei2exH7JftYXUrk80k9eCn+DGTqoxSCkvM27+TWxCRwGgu2H
	6lqgGEhJuZ7DYkK4cJXVexgNGES7lhey+
X-Received: by 2002:aa7:d987:0:b0:6ab:6e:a8e4 with SMTP id 4fb4d7f45d1cf-6b5978378a2mr2719660a12.44.1794070377007;
        Sat, 07 Nov 2026 08:52:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b65d6b3811sm1908827a12.5.2026.11.07.08.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:52:56 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ovl: do not check the deferred lowerdata redirect on index lookup
Date: Sat,  7 Nov 2026 17:52:54 +0100
Message-ID: <20261107165254.3989119-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107165254.3989119-1-amir73il@gmail.com>
References: <20261107165254.3989119-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a lower metacopy has an absolute redirect into a data-only layer,
ovl_lookup_layers() defers the data lookup and skips
ovl_check_follow_redirect(), but leaves the redirect in d->redirect.
If there is no upper dentry and a sibling hardlink was already copied
up to the index dir, the index branch calls ovl_check_follow_redirect()
again and, with redirect_dir=nofollow (e.g. forced by userxattr), fails
the lookup with -EPERM because of the lower data redirect.

Take the lowerdata redirect out of d->redirect at the point where the
data lookup is deferred, so that the index check only validates the
redirect and metacopy state of the index entry.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Closes: https://sashiko.dev/#/bug/linux-29bea9ea-5376-4e54-88f6-04dabce4db70
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e25858c8dbcd7..b7fb5bb2e597f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -27,6 +27,7 @@ struct ovl_lookup_data {
 	bool last;
 	char *redirect;
 	char *upperredirect;
+	char *lowerdata_redirect;
 	int metacopy;
 	/* Referring to last redirect xattr */
 	bool absolute_redirect;
@@ -1250,6 +1251,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 	if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolute_redirect) {
 		d->metacopy = 0;
 		ctx->ctr++;
+		d->lowerdata_redirect = d->redirect;
+		d->redirect = NULL;
 	} else if (!ovl_check_follow_redirect(d)) {
 		err = -EPERM;
 		return err;
@@ -1366,15 +1369,14 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 		};
 
 		/* Store lowerdata redirect for lazy lookup */
-		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry)
-			oip.lowerdata_redirect = d->redirect;
+		if (d->lowerdata_redirect)
+			oip.lowerdata_redirect = d->lowerdata_redirect;
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
-		if (oip.lowerdata_redirect)
-			d->redirect = NULL;
+		d->lowerdata_redirect = NULL;
 
 		ctx->inode = inode;
 		if (ctx->upperdentry && !uppermetacopy)
@@ -1427,6 +1429,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(ctx.index);
 	ovl_stack_free(ctx.stack, ctx.ctr);
 	kfree(d.redirect);
+	kfree(d.lowerdata_redirect);
 
 	if (err) {
 		ovl_free_entry(ctx.oe);
-- 
2.56.0

