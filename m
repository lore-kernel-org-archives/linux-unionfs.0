Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEC857311
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 09:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706000709; cv=none; b=KQwKvlrsOA5qIqsEX73JoPDYYDLzL8WR3z/HUTLo4ohq+qrrHW8yNLlreFD5sPbVzeJY1yjA5412qjyBON112yf8YAMrs2q7Snf63oxz7rCueMLsaXQvqJhA3Ych8QhGXMWTrBvjD9kxUkHrHcjzCAYq638NXPC689bgtuZ2zr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706000709; c=relaxed/simple;
	bh=kznsdJi6lI0Jls9+dJDyhIwARAaxKJ2zeqJRORAjR/Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjDhqUmL4cQ+GpA1vVhCkEeGSecjMyyBbWyvpvHVAzlMccOCzzTukH+KBdkuqSbQBycb2lU/VUwUue0hQgtCLvkSIyuy3uHQIiT0PKmvXqdVmu61bczzIzi1oH56zkENIQwThaTvvM2SY5LKOWBPgDxOzMNVk0WIMg7J7rYO/H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NgNLDpDD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NgNLDpDD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706000705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zmoS8juKTa/nCROQmP/WiMYV2guU2syKw4SiAkJ2C78=;
	b=NgNLDpDDdY+fX53FhYXumxVCFBLbXtaKVyupHBRGurAurF9FQZQOKGpf1hil7BVs0aBE7o
	rAQetBchnmtnCYO+bv7jElare5v6qXGPlJO+D5P5p31IW5trq7xyp7F4U6A7qToE/1Elax
	NkSQ3ouXoQQmjQz4rczwg5SMHfgkj4U=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-qt5hUyihOh2ao5j0ONeQiw-1; Tue, 23 Jan 2024 04:05:04 -0500
X-MC-Unique: qt5hUyihOh2ao5j0ONeQiw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2cf191f8dbcso343381fa.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 01:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706000702; x=1706605502;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmoS8juKTa/nCROQmP/WiMYV2guU2syKw4SiAkJ2C78=;
        b=I893aUb8TeopVKi0TKvV0krfsXTzCm/+PWsS6JrbqF4WmZ9Q8MBjsAAO23dgea+3zK
         UIEKy6oZQ30PuCR5AtuopwWo5Arq01+Z0DYA19PacHWqPhpVn8Se8JveGOuZHeNJhx2t
         qMbH/nc9lCqGAs5LnT7BIpWQiKRtAtPSzMf4ougiQF6ReRMMEjVntgGC0XKzOlHjGP3D
         mb24vdCfHmg0snGGL/EN0EKNAwOTD99znY5rRuBDBntT4JIudrDVjEPACzxKwreQWdIi
         MOKJngX3T6D9rTdT3dDqQaEC2wEYSQ+P+1bZDwVW39mqkEhME8HygaMPWUYt8262O7o6
         tpNA==
X-Gm-Message-State: AOJu0Yy0AvBcZaWmrR2ZJy7rVIch9LNSxbMrQBzCRDFWTBPzyByNiFzX
	/ekSzUPN1jUmm/LvMQA2k9vU1q27n5TGTOhmlw06bap7I7cwiCM22UzLsygFbS6qYgP/Uyx3xnr
	VmS9S7DsCEE3IvFV7lA4eWwBJaAMa10zygjFuxmDvqDbPYGuV79W9+uZ9B/uR6NdaIh3/QiE=
X-Received: by 2002:a2e:a362:0:b0:2cc:9860:e34e with SMTP id i2-20020a2ea362000000b002cc9860e34emr2170653ljn.56.1706000701755;
        Tue, 23 Jan 2024 01:05:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMBkeIhcMpStunBgnQQIIyr5hEc25Ounw4bzkpBQo2lkfik7xXNLqSE7IbS74zv2ytvnMrwg==
X-Received: by 2002:a2e:a362:0:b0:2cc:9860:e34e with SMTP id i2-20020a2ea362000000b002cc9860e34emr2170637ljn.56.1706000701069;
        Tue, 23 Jan 2024 01:05:01 -0800 (PST)
Received: from [172.31.0.10] (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id w5-20020a2ea3c5000000b002cceb7bd648sm3694051lje.92.2024.01.23.01.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 01:05:00 -0800 (PST)
Message-ID: <734d0570edb1a8150c902e6bdd509b597deea186.camel@redhat.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with
 overlay.opaque='x'
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
Date: Tue, 23 Jan 2024 10:04:59 +0100
In-Reply-To: <20240122195100.452360-1-amir73il@gmail.com>
References: <20240122195100.452360-1-amir73il@gmail.com>
Autocrypt: addr=alexl@redhat.com; prefer-encrypt=mutual; keydata=mQGiBEP1jxURBACW8O2adxbdh0uG6EMoqk+oAkzYXBKdnhRubyHHYuj+QL6b3pP9N2bD3AGUyaaXiaTlHMzn7g6HAxPFXpI5jMfAASbgbI3U/PAQS3h4bifp1YRoM8UmE1ziq9RthVPL6oA8dxHI2lZrC/28Kym7uX/pvZMjrzcLnk2fSchB7QIWAwCg2GESCY5o4GUbnp/KyIs6WsjupRMD/i2hSnH6MrjDPQZgqJa8d22p5TuwIxXiShnTNTy5Ey/MlKsPk6AOjUAlFbqy9tw1g2r1nlHj0noM+27TkihShMrDWDJLzRexz8s/wB9S2oIGCPw6tzfYnEkpyRWNUWr1wg2Qb+4JhEP8qHKD6YDpZudZhDwS+UXGyCrbVsfp3dZWA/9Q7lSIBjPqfTnFpPdxz7hGAFHnPQP0ufcgyluvbR68ZnTK6ooPgTeArEZO2ryF8bFm31PPHbkBCoJ5VLQGupY9xFBmCjxPLJESx1+m2HB9+zED3LM0zjJ7ViJcyK02wLeSlzXt7LWFYOZVklJ6Ox6vVKNXczS0CXqZAA1cPxZlIrQkQWxleGFuZGVyIExhcnNzb24gPGFsZXhsQHJlZGhhdC5jb20+iGQEExECACQFAkP1jxUCGwMFCQPCZwAGCwkIBwMCAxUCAwMWAgECHgECF4AACgkQmI0nkN8TYr5UngCgwrKNejiglHH181N5HW2VHgtlpMAAn046j6Muu6gnykJqmaAesuq6vfYfmQGiBEgx0csRBAD6YYAG+iA0eAnNbw0CQ/WtSpV7i8NLKxSTpr0ooEAgUfWHCTP4xxY2KQDECEgVsveq2T0TcycgSK/1W/n7mI13NN++6S4Btz2qH5Bf29CqF2CBxUrmC3LWITcMyFxtdpzKInWgyQDfOWopgnKQQBaMJW7NKHF5DYhaC9UNMDbPu
 wCgoGbE1bvBh9Tg6KMWlBK+PsHFkC8D/RX+IA0ldyvw2G/jXnqK4gDHD c3Ab/Nofxzc1NTKoAxEsqWHRfxptyxA+rVZ4jVJHEHw5LOTojGjUqrUiqoFDcw3htp0V6zsUEYmaDTVZfVBf5K62BD2h58vH6O0oK8UYWn0NomHQ/t1urL+qFG1Nf/wI29ExFRkYORZXLQau1faBADf4Q9g6DRT/CfWMcbsGJcAN7uaB6xlQXenlc4INPo5KF4XTxWV+UbxK2OzxHHEBA9EQ2mDj0WuqWII100pd6fIF8rmpc+gvIcxKDCbgQ/I1Wr59It/QMIZcK2xF/p4V05QWKtXDE2AbKlab1T7WSfGewACI84LSF/qATZRm9xWu7QkQWxleGFuZGVyIExhcnNzb24gPGFsZXhsQHJlZGhhdC5jb20+iGAEExECACAFAkgx0csCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDrYhbdt2xw6djpAJ42jsKMjBplAxRg9IPQVHt7iMhzEQCfV4TG/nT1x+WnfKAuLNZnFbrrg+u5Ag0ESDHRyxAIAKn2usr3eOALd9FQodwFTNeRcTUIA+OPOO5HCwWLiuSoL1ttgrgOVlUbDrJU8+1w+y3cnJafysDonTv1u0lPdCEarxxafRLTQ6AsQgCdAkaIFXidQvLRVds9J7Gm787XhFEOqKcRfKtnELVjOpPZxPDZwDgwlUnDCNv7J8yb39oac2vcFiJDl/07XdCcEsk/E1gnZUKwqVDPjfNoTC6RSZqOEnbrij4WV+ZAP+nNA1+u5TkfWYRpgHPbY6FU1V+hESmC364JI+0x/+PB3VXov/dMgzpwrbIzXD7vMg186LVi+5tiVseY3ABpCXFulIgi10oYTLG7kNQXkry5/CcoZc8AAwUIAJ4KyLrUTsouUQ5GpmFbm/6QstHxxOow5hmfVSRjDHQ/og9G1m6q5cE/IOdKSPcW226PYFXadGDQ7
 dgT02yCQmr4cmIeoYPKIUeczK6olJwxLT/fw+CHabFa0Zi9WOwHlDrxZz c0bTAS6sB9JU/cu690q9D8KEnlze3MARihAgN6vrFUBTbOy1wGQdv+Rx3kNMjHSeWYqHh/cmzbun46dYI4veCsHXW2dsD1dD/Dw8ZNVey5O6/39aS8JWF9aL47iI5Kd9btFD88dNjV6SDXH5Gg5XIHWMU1T1EwTtjahuinZhagbjRYefoKzHRGbDucVHWGzwK+ErUoYoijx+xytueISQQYEQIACQUCSDHRywIbDAAKCRDrYhbdt2xw6b8EAJ48WXrgflR7UcbbyHma4g5uXSqswwCeKuxnZjkxOkPckOybOLt/m1VtsVOZAQ0EVhJRwQEIALnSxFUPLjQDSYX8vzvuA+mM/YZW6dD5UZ3k1jQw/CVLEbZPEzRXB8CMdm8NxbEpXTzjZtV8BdbOZvEyJVFkoUkwCyNaimy68UKDXiHjKwElgvRPiCZpM6fj13xZSnInM3Ux5LwYQ5W81Rr7D+r5Jxbz9wgJ6vOQxKKJDODzo+HRhO+mwXL995I9mTlV9jbw3DnbTgM7rPTr6Lge4ebvC7y5I+7dM2tDBI+CoX4J5jWcefD8tkhjp1HKSRY6w6d/I9J3QQrxBgkPqrqLUk5y1e60b+BHga9umuANqC0lClCYcdoaeh7Sokc4PRM537uYSJ6XQB/I8zCTNyhuLkvB/CMAEQEAAbQqTmlnaHRseSBhcHAgYXV0b2J1aWxkZXIgPGFsZXhsQHJlZGhhdC5jb20+iQE3BBMBCAAhBQJWElHBAhsDBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEGp8XUSCFw49WqIIAJ4PrvKli4GP5/HVN+bdv3NbsTeDYUjWAtwrUpi9rz2kTUhSZiIVvouT+laA1mmxtyGxfF3tw6HfWnrrPVH8zPXRdg7n/ffPiWuwlidrbSKy3sZ/ez5/xaCDfVPbwN2FE/sgP
 yaOxkmjaJO61pYTAAAPbeCCwR5bWTMywiI6rNsn5ZcaFC/aR19c4uANIkS VofeBex3rSxuDElUMPshjGgidu/oL9Zdz36stxjvOtq4AhGgOswhvlncQTtInkg2EHcD2gzR9Uh8aj0zW02ST8Uhupid7TtGZv7i+gDbDJPXAEeyrPkb4XGQU7X6ADItzcBQdIdUVfuJB3nHiz3XD4nm5AQ0EVhJRwQEIALYQ3XuqExEQNFVjv+PqqPcKZAH/05M21Z7EmKalD+rrRrcusTQoC7XR45X4h5RFBzHYJHEdIhfeQACk5K7TG5839+WpYt8Tf2IvClzCenh+wRimGWvDlqCQVTOR7HYnH77cuWni/cVegzUWaCjwbMDMqWTQkWqzNB/YUDnC6kWHSFze7RzCWfdbgiW5ca94ChoXVZlOyM/AnxC2y2l3rzzTVlv2Md7P7waQGTloWTG865kW9cZHA7Kjk7xHKMUURpGqLpYQE0ZhyayKGBKDd82LWG09jXwCpRxpmsFpJDfpEwLu09tBlAauDjSFaU+sxa/McM866yZRgfzGwAeN258AEQEAAYkBHwQYAQgACQUCVhJRwQIbDAAKCRBqfF1EghcOPayOB/4pyF4zhAkJWGfFyy/eB5TIZFqC6zAgOpZzrG/pJypMuA4FKVpVyqtu1USslcg3Frl9vd5ftSa4JXJI+Q+iKnUgEfTv7O8q06Wo5gh0V32hoCqZHFfiImI2v/vRzsaLT3GDwRZjsEouiwuiMiez8drBnuQs7etE8aMRXSghq8fyOJoAebqunp3lrAZpk/pzv5m4H6gUhlPvVGwWg08eFEoh3hwLjN1wrVULMl6npV6Sl6kKaaHbrhMl2t9rRMQ4DG3gNNArPSAJggqDxBGljD9RGL+Q/XleT8VucbyFzay9367uYJ3cUS+G5/bm3ssGZTGwBYJH0dGB2eQVp8A1prYkmQENBFYg/CYBCADWh19QL5eoGfOzc67xdc1NY
 cg5SvM7efggKhADJXu/PKe4g5/wDX/8Q/G2s8FKo3t527Ahx/8BlPR/cCek yAAYYknTLvZIUAGQvnZLDKgOmrnsadKrmhhyIWGxyZe8/aqV9GaaD2nzXzMLoxE48ucy3tK8VELR4ipibb7YvmjWG7zoK7yH51Am2u76/7TX1yV19ofjN6hr2SpmjSU5hL6RcRkSY+/Rwr+63IpwEnNmIlWXRe2R8nfB8b5uHhXte9Mb3IJQ+lm758bYZUNX4nCZCWPHjhqc0VlO6tuDc6G3abYWbld2LXys3ZgTU6aBqAtQz59U0zrGqmk0ACcuXhw7ABEBAAG0Jk5pZ2h0bHkgbG9jYWwgYnVpbGQgPGFsZXhsQHJlZGhhdC5jb20+iQE3BBMBCAAhBQJWIPwmAhsDBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEAyxtrVWaIWGMQcH+wS62GiJ3zz7ck8RJCc9uhcsYreZjrGZF0Yf0e4IQUuSMxKID7KGUcIRiPROwF2/vgzSO3HJ/WcIALlEqURgVGxp08MXJExowDAUS6Tu6RRdt/bUNYwufu86ZcbSTii/9X3DlxYc/tBSP7T7dnNux+UtyQ2LLH6SQoEs7NkCj0E07ThWbWYPZikvwEZ5gTZSDdRs0hiv/F1YnwqSIeijPBtIqXx035/GF+5D6kopUEHheDi1MSj5ZnFR/YaVl6Z78arnqXVLo9P4RZl6ys4Y1o7PDdUVjgB9VNpoSpkganfSPj5HNXRfiwPpUucEIveKWpyH4f5fgwcMYfzBX6KSRLO5AQ0EViD8JgEIAOZQcfDTJWDybC/B6GHLBojvlOmjzweoQce6NNuda02PPv9gvogHnS1RegKio0ynozpmgn0w8UjSTqbO3PgvlYGxau+TOktXwzAAEVLyLu8SZyPOim+qHU5+4vUJPnlS4WPVv8SuMsWexdVMsfSch9slG8c/lPcMYvPAwuBngDrHyoKEDgLwEM+8E
 uHgyH9eKtT/To/rnLTXFdPKjGGB/3FAgf7p7nv82g65X+VEibIWg+IQWGZQe TYjYhSF6+dgunmbLDOm7SjSNBtD4bxUpYpwPGP1QN6stbvr5DquaNxHmYa/b2kegvoEfLUshZMqRoQCFCfpAUqGF97y0aAHz2UAEQEAAYkBHwQYAQgACQUCViD8JgIbDAAKCRAMsba1VmiFhn52B/0an3HE0FTS9fwHMABISOmdowCIFQ8T0V+5EAHJRCSubZARiU34CIQ80E25zCnkQDJ/wXnodnLKsR+NMVy36BbufUnlSq5HNRo8ZCQuSl3ROjs1IgRb0XDjKiqTQGmbqshyON0af3inFIms6Hvfmk64AnuPVfwvAAWdM93XF3QkothbN5MxxKe9xcuFecFEnwplhSCEq3LZhe1Ks3sorvTM7n/KxW+gAlDzP4Et31hInUAbRBaw6KoxCLPK3HeDBlV1/zZ8hhUpefNpd4pkL7lGaePBsMPz0QD1AkqVDRmvx9hdRnZ8qJu2tQSrq9d9xS+c3abOCxIxLoxyyMIg3jFG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-01-22 at 21:51 +0200, Amir Goldstein wrote:
> An opaque directory cannot have xwhiteouts, so instead of marking an
> xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> for marking both opaque dir ('y') and xwhiteouts dir ('x').
>=20
> This is more efficient as the overlay.opaque xattr is checked during
> lookup of directory anyway.
>=20
> This also prevents unnecessary checking the xattr when reading a
> directory without xwhiteouts, i.e. most of the time.
>=20
> Note that the xwhiteouts marker is not checked on the upper layer and
> on the last layer in lowerstack, where xwhiteouts are not expected.
>=20
> Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> Cc: <stable@vger.kernel.org> # v6.7
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>=20
> Miklos,
>=20
> This v4 is a combination of your v2 and my v3 patches to optimize
> xwhiteouts readdir for the intersection of a dentry with xwhiteouts
> on any layer and a layer with any xwhiteouts on any directory.
>=20
> Alex,
>=20
> Please re-review/test.

Looks good to me. The only thing I worry about is the atomicity of
ovl_layer_set_xwhiteouts(). Doesn't that need a barrier or something?

Anyway:

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Tested-by: Alexander Larsson <alexl@redhat.com>


> Thanks,
> Amir.
>=20
> Changes since v3:
> - Lazy set of per-layer xwhiteouts flag
> - Check both per-layer and per-dir flags for readdir
> - Update overlayfs.rst
>=20
> =C2=A0Documentation/filesystems/overlayfs.rst | 16 +++++++--
> =C2=A0fs/overlayfs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 43 =
++++++++++++++---------
> =C2=A0fs/overlayfs/overlayfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 +++++++++----
> =C2=A0fs/overlayfs/ovl_entry.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> =C2=A0fs/overlayfs/readdir.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 ++--
> =C2=A0fs/overlayfs/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 15 =
++++++++
> =C2=A0fs/overlayfs/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
46 +++++++++++++----------
> --
> =C2=A07 files changed, 102 insertions(+), 50 deletions(-)
>=20
> diff --git a/Documentation/filesystems/overlayfs.rst
> b/Documentation/filesystems/overlayfs.rst
> index 1c244866041a..165514401441 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -145,7 +145,9 @@ filesystem, an overlay filesystem needs to record
> in the upper filesystem
> =C2=A0that files have been removed.=C2=A0 This is done using whiteouts an=
d
> opaque
> =C2=A0directories (non-directories are always opaque).
> =C2=A0
> -A whiteout is created as a character device with 0/0 device number.
> +A whiteout is created as a character device with 0/0 device number
> or
> +as a zero-size regular file with the xattr
> "trusted.overlay.whiteout".
> +
> =C2=A0When a whiteout is found in the upper level of a merged directory,
> any
> =C2=A0matching name in the lower level is ignored, and the whiteout itsel=
f
> =C2=A0is also hidden.
> @@ -154,6 +156,13 @@ A directory is made opaque by setting the xattr
> "trusted.overlay.opaque"
> =C2=A0to "y".=C2=A0 Where the upper filesystem contains an opaque directo=
ry,
> any
> =C2=A0directory in the lower filesystem with the same name is ignored.
> =C2=A0
> +An opaque directory should not conntain any whiteouts, because they
> do not
> +serve any purpose.=C2=A0 A merge directory containing regular files with
> the xattr
> +"trusted.overlay.whiteout", should be additionally marked by setting
> the xattr
> +"trusted.overlay.opaque" to "x" on the merge directory itself.
> +This is needed to avoid the overhead of checking the
> "trusted.overlay.whiteout"
> +on all entries during readdir in the common case.
> +
> =C2=A0readdir
> =C2=A0-------
> =C2=A0
> @@ -534,8 +543,9 @@ A lower dir with a regular whiteout will always
> be handled by the overlayfs
> =C2=A0mount, so to support storing an effective whiteout file in an
> overlayfs mount an
> =C2=A0alternative form of whiteout is supported. This form is a regular,
> zero-size
> =C2=A0file with the "overlay.whiteout" xattr set, inside a directory with
> the
> -"overlay.whiteouts" xattr set. Such whiteouts are never created by
> overlayfs,
> -but can be used by userspace tools (like containers) that generate
> lower layers.
> +"overlay.opaque" xattr set to "x" (see `whiteouts and opaque
> directories`_).
> +These alternative whiteouts are never created by overlayfs, but can
> be used by
> +userspace tools (like containers) that generate lower layers.
> =C2=A0These alternative whiteouts can be escaped using the standard xattr
> escape
> =C2=A0mechanism in order to properly nest to any depth.
> =C2=A0
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 984ffdaeed6c..5764f91d283e 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -18,10 +18,11 @@
> =C2=A0
> =C2=A0struct ovl_lookup_data {
> =C2=A0	struct super_block *sb;
> -	struct vfsmount *mnt;
> +	const struct ovl_layer *layer;
> =C2=A0	struct qstr name;
> =C2=A0	bool is_dir;
> =C2=A0	bool opaque;
> +	bool xwhiteouts;
> =C2=A0	bool stop;
> =C2=A0	bool last;
> =C2=A0	char *redirect;
> @@ -201,17 +202,13 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs
> *ofs, struct ovl_fh *fh,
> =C2=A0	return real;
> =C2=A0}
> =C2=A0
> -static bool ovl_is_opaquedir(struct ovl_fs *ofs, const struct path
> *path)
> -{
> -	return ovl_path_check_dir_xattr(ofs, path,
> OVL_XATTR_OPAQUE);
> -}
> -
> =C2=A0static struct dentry *ovl_lookup_positive_unlocked(struct
> ovl_lookup_data *d,
> =C2=A0						=C2=A0=C2=A0 const char *name,
> =C2=A0						=C2=A0=C2=A0 struct dentry
> *base, int len,
> =C2=A0						=C2=A0=C2=A0 bool
> drop_negative)
> =C2=A0{
> -	struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->mnt),
> name, base, len);
> +	struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->layer-
> >mnt), name,
> +						 base, len);
> =C2=A0
> =C2=A0	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret-
> >d_flags))) {
> =C2=A0		if (drop_negative && ret->d_lockref.count =3D=3D 1) {
> @@ -232,10 +229,13 @@ static int ovl_lookup_single(struct dentry
> *base, struct ovl_lookup_data *d,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 size_t prelen, const char *post,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 struct dentry **ret, bool
> drop_negative)
> =C2=A0{
> +	struct ovl_fs *ofs =3D OVL_FS(d->sb);
> =C2=A0	struct dentry *this;
> =C2=A0	struct path path;
> =C2=A0	int err;
> =C2=A0	bool last_element =3D !post[0];
> +	bool is_upper =3D d->layer->idx =3D=3D 0;
> +	char val;
> =C2=A0
> =C2=A0	this =3D ovl_lookup_positive_unlocked(d, name, base, namelen,
> drop_negative);
> =C2=A0	if (IS_ERR(this)) {
> @@ -253,8 +253,8 @@ static int ovl_lookup_single(struct dentry *base,
> struct ovl_lookup_data *d,
> =C2=A0	}
> =C2=A0
> =C2=A0	path.dentry =3D this;
> -	path.mnt =3D d->mnt;
> -	if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
> +	path.mnt =3D d->layer->mnt;
> +	if (ovl_path_is_whiteout(ofs, &path)) {
> =C2=A0		d->stop =3D d->opaque =3D true;
> =C2=A0		goto put_and_out;
> =C2=A0	}
> @@ -272,7 +272,7 @@ static int ovl_lookup_single(struct dentry *base,
> struct ovl_lookup_data *d,
> =C2=A0			d->stop =3D true;
> =C2=A0			goto put_and_out;
> =C2=A0		}
> -		err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path,
> NULL);
> +		err =3D ovl_check_metacopy_xattr(ofs, &path, NULL);
> =C2=A0		if (err < 0)
> =C2=A0			goto out_err;
> =C2=A0
> @@ -292,7 +292,12 @@ static int ovl_lookup_single(struct dentry
> *base, struct ovl_lookup_data *d,
> =C2=A0		if (d->last)
> =C2=A0			goto out;
> =C2=A0
> -		if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
> +		/* overlay.opaque=3Dx means xwhiteouts directory */
> +		val =3D ovl_get_opaquedir_val(ofs, &path);
> +		if (last_element && !is_upper && val =3D=3D 'x') {
> +			d->xwhiteouts =3D true;
> +			ovl_layer_set_xwhiteouts(ofs, d->layer);
> +		} else if (val =3D=3D 'y') {
> =C2=A0			d->stop =3D true;
> =C2=A0			if (last_element)
> =C2=A0				d->opaque =3D true;
> @@ -863,7 +868,8 @@ struct dentry *ovl_lookup_index(struct ovl_fs
> *ofs, struct dentry *upper,
> =C2=A0 * Returns next layer in stack starting from top.
> =C2=A0 * Returns -1 if this is the last layer.
> =C2=A0 */
> -int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
> +int ovl_path_next(int idx, struct dentry *dentry, struct path *path,
> +		=C2=A0 const struct ovl_layer **layer)
> =C2=A0{
> =C2=A0	struct ovl_entry *oe =3D OVL_E(dentry);
> =C2=A0	struct ovl_path *lowerstack =3D ovl_lowerstack(oe);
> @@ -871,13 +877,16 @@ int ovl_path_next(int idx, struct dentry
> *dentry, struct path *path)
> =C2=A0	BUG_ON(idx < 0);
> =C2=A0	if (idx =3D=3D 0) {
> =C2=A0		ovl_path_upper(dentry, path);
> -		if (path->dentry)
> +		if (path->dentry) {
> +			*layer =3D &OVL_FS(dentry->d_sb)->layers[0];
> =C2=A0			return ovl_numlower(oe) ? 1 : -1;
> +		}
> =C2=A0		idx++;
> =C2=A0	}
> =C2=A0	BUG_ON(idx > ovl_numlower(oe));
> =C2=A0	path->dentry =3D lowerstack[idx - 1].dentry;
> -	path->mnt =3D lowerstack[idx - 1].layer->mnt;
> +	*layer =3D lowerstack[idx - 1].layer;
> +	path->mnt =3D (*layer)->mnt;
> =C2=A0
> =C2=A0	return (idx < ovl_numlower(oe)) ? idx + 1 : -1;
> =C2=A0}
> @@ -1055,7 +1064,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0	old_cred =3D ovl_override_creds(dentry->d_sb);
> =C2=A0	upperdir =3D ovl_dentry_upper(dentry->d_parent);
> =C2=A0	if (upperdir) {
> -		d.mnt =3D ovl_upper_mnt(ofs);
> +		d.layer =3D &ofs->layers[0];
> =C2=A0		err =3D ovl_lookup_layer(upperdir, &d, &upperdentry,
> true);
> =C2=A0		if (err)
> =C2=A0			goto out;
> @@ -1111,7 +1120,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0		else if (d.is_dir || !ofs->numdatalayer)
> =C2=A0			d.last =3D lower.layer->idx =3D=3D
> ovl_numlower(roe);
> =C2=A0
> -		d.mnt =3D lower.layer->mnt;
> +		d.layer =3D lower.layer;
> =C2=A0		err =3D ovl_lookup_layer(lower.dentry, &d, &this,
> false);
> =C2=A0		if (err)
> =C2=A0			goto out_put;
> @@ -1278,6 +1287,8 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0
> =C2=A0	if (upperopaque)
> =C2=A0		ovl_dentry_set_opaque(dentry);
> +	if (d.xwhiteouts)
> +		ovl_dentry_set_xwhiteouts(dentry);
> =C2=A0
> =C2=A0	if (upperdentry)
> =C2=A0		ovl_dentry_set_upper_alias(dentry);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 5ba11eb43767..ee949f3e7c77 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -50,7 +50,6 @@ enum ovl_xattr {
> =C2=A0	OVL_XATTR_METACOPY,
> =C2=A0	OVL_XATTR_PROTATTR,
> =C2=A0	OVL_XATTR_XWHITEOUT,
> -	OVL_XATTR_XWHITEOUTS,
> =C2=A0};
> =C2=A0
> =C2=A0enum ovl_inode_flag {
> @@ -70,6 +69,8 @@ enum ovl_entry_flag {
> =C2=A0	OVL_E_UPPER_ALIAS,
> =C2=A0	OVL_E_OPAQUE,
> =C2=A0	OVL_E_CONNECTED,
> +	/* Lower stack may contain xwhiteout entries */
> +	OVL_E_XWHITEOUTS,
> =C2=A0};
> =C2=A0
> =C2=A0enum {
> @@ -477,6 +478,10 @@ bool ovl_dentry_test_flag(unsigned long flag,
> struct dentry *dentry);
> =C2=A0bool ovl_dentry_is_opaque(struct dentry *dentry);
> =C2=A0bool ovl_dentry_is_whiteout(struct dentry *dentry);
> =C2=A0void ovl_dentry_set_opaque(struct dentry *dentry);
> +bool ovl_dentry_has_xwhiteouts(struct dentry *dentry);
> +void ovl_dentry_set_xwhiteouts(struct dentry *dentry);
> +void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct ovl_layer *layer);
> =C2=A0bool ovl_dentry_has_upper_alias(struct dentry *dentry);
> =C2=A0void ovl_dentry_set_upper_alias(struct dentry *dentry);
> =C2=A0bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int
> flags);
> @@ -494,11 +499,10 @@ struct file *ovl_path_open(const struct path
> *path, int flags);
> =C2=A0int ovl_copy_up_start(struct dentry *dentry, int flags);
> =C2=A0void ovl_copy_up_end(struct dentry *dentry);
> =C2=A0bool ovl_already_copied_up(struct dentry *dentry, int flags);
> -bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path
> *path,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum ovl_xattr ox);
> +char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path
> *path,
> +			=C2=A0=C2=A0 enum ovl_xattr ox);
> =C2=A0bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct
> path *path);
> =C2=A0bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struc=
t
> path *path);
> -bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const
> struct path *path);
> =C2=A0bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs=
,
> =C2=A0			 const struct path *upperpath);
> =C2=A0
> @@ -573,7 +577,13 @@ static inline bool ovl_is_impuredir(struct
> super_block *sb,
> =C2=A0		.mnt =3D ovl_upper_mnt(ofs),
> =C2=A0	};
> =C2=A0
> -	return ovl_path_check_dir_xattr(ofs, &upperpath,
> OVL_XATTR_IMPURE);
> +	return ovl_get_dir_xattr_val(ofs, &upperpath,
> OVL_XATTR_IMPURE) =3D=3D 'y';
> +}
> +
> +static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
> +					 const struct path *path)
> +{
> +	return ovl_get_dir_xattr_val(ofs, path, OVL_XATTR_OPAQUE);
> =C2=A0}
> =C2=A0
> =C2=A0static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
> @@ -680,7 +690,8 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct
> dentry *origin,
> =C2=A0struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh
> *fh);
> =C2=A0struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry
> *upper,
> =C2=A0				struct dentry *origin, bool verify);
> -int ovl_path_next(int idx, struct dentry *dentry, struct path
> *path);
> +int ovl_path_next(int idx, struct dentry *dentry, struct path *path,
> +		=C2=A0 const struct ovl_layer **layer);
> =C2=A0int ovl_verify_lowerdata(struct dentry *dentry);
> =C2=A0struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> =C2=A0			=C2=A0 unsigned int flags);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 5fa9c58af65f..b26d1824bf87 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -40,6 +40,8 @@ struct ovl_layer {
> =C2=A0	int idx;
> =C2=A0	/* One fsid per unique underlying sb (upper fsid =3D=3D 0) */
> =C2=A0	int fsid;
> +	/* xwhiteouts were found on this layer */
> +	bool has_xwhiteouts;
> =C2=A0};
> =C2=A0
> =C2=A0struct ovl_path {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e71156baa7bc..0ca8af060b0c 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -305,8 +305,6 @@ static inline int ovl_dir_read(const struct path
> *realpath,
> =C2=A0	if (IS_ERR(realfile))
> =C2=A0		return PTR_ERR(realfile);
> =C2=A0
> -	rdd->in_xwhiteouts_dir =3D rdd->dentry &&
> -		ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry-
> >d_sb), realpath);
> =C2=A0	rdd->first_maybe_whiteout =3D NULL;
> =C2=A0	rdd->ctx.pos =3D 0;
> =C2=A0	do {
> @@ -359,10 +357,13 @@ static int ovl_dir_read_merged(struct dentry
> *dentry, struct list_head *list,
> =C2=A0		.is_lowest =3D false,
> =C2=A0	};
> =C2=A0	int idx, next;
> +	const struct ovl_layer *layer;
> =C2=A0
> =C2=A0	for (idx =3D 0; idx !=3D -1; idx =3D next) {
> -		next =3D ovl_path_next(idx, dentry, &realpath);
> +		next =3D ovl_path_next(idx, dentry, &realpath,
> &layer);
> =C2=A0		rdd.is_upper =3D ovl_dentry_upper(dentry) =3D=3D
> realpath.dentry;
> +		rdd.in_xwhiteouts_dir =3D layer->has_xwhiteouts &&
> +					ovl_dentry_has_xwhiteouts(de
> ntry);
> =C2=A0
> =C2=A0		if (next !=3D -1) {
> =C2=A0			err =3D ovl_dir_read(&realpath, &rdd);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4ab66e3d4cff..2eef6c70b2ae 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1249,6 +1249,7 @@ static struct dentry *ovl_get_root(struct
> super_block *sb,
> =C2=A0				=C2=A0=C2=A0 struct ovl_entry *oe)
> =C2=A0{
> =C2=A0	struct dentry *root;
> +	struct ovl_fs *ofs =3D OVL_FS(sb);
> =C2=A0	struct ovl_path *lowerpath =3D ovl_lowerstack(oe);
> =C2=A0	unsigned long ino =3D d_inode(lowerpath->dentry)->i_ino;
> =C2=A0	int fsid =3D lowerpath->layer->fsid;
> @@ -1270,6 +1271,20 @@ static struct dentry *ovl_get_root(struct
> super_block *sb,
> =C2=A0			ovl_set_flag(OVL_IMPURE, d_inode(root));
> =C2=A0	}
> =C2=A0
> +	/* Look for xwhiteouts marker except in the lowermost layer
> */
> +	for (int i =3D 0; i < ovl_numlower(oe) - 1; i++, lowerpath++)
> {
> +		struct path path =3D {
> +			.mnt =3D lowerpath->layer->mnt,
> +			.dentry =3D lowerpath->dentry,
> +		};
> +
> +		/* overlay.opaque=3Dx means xwhiteouts directory */
> +		if (ovl_get_opaquedir_val(ofs, &path) =3D=3D 'x') {
> +			ovl_layer_set_xwhiteouts(ofs, lowerpath-
> >layer);
> +			ovl_dentry_set_xwhiteouts(root);
> +		}
> +	}
> +
> =C2=A0	/* Root is always merge -> can have whiteouts */
> =C2=A0	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
> =C2=A0	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0217094c23ea..5667f21d0b73 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -461,6 +461,26 @@ void ovl_dentry_set_opaque(struct dentry
> *dentry)
> =C2=A0	ovl_dentry_set_flag(OVL_E_OPAQUE, dentry);
> =C2=A0}
> =C2=A0
> +bool ovl_dentry_has_xwhiteouts(struct dentry *dentry)
> +{
> +	return ovl_dentry_test_flag(OVL_E_XWHITEOUTS, dentry);
> +}
> +
> +void ovl_dentry_set_xwhiteouts(struct dentry *dentry)
> +{
> +	ovl_dentry_set_flag(OVL_E_XWHITEOUTS, dentry);
> +}
> +
> +void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct ovl_layer *layer)
> +{
> +	if (layer->has_xwhiteouts)
> +		return;
> +
> +	/* Write once to read-mostly layer properties */
> +	((struct ovl_layer *)layer)->has_xwhiteouts =3D true;
> +}
> +
> =C2=A0/*
> =C2=A0 * For hard links and decoded file handles, it's possible for
> ovl_dentry_upper()
> =C2=A0 * to return positive, while there's no actual upper alias for the
> inode.
> @@ -739,19 +759,6 @@ bool ovl_path_check_xwhiteout_xattr(struct
> ovl_fs *ofs, const struct path *path)
> =C2=A0	return res >=3D 0;
> =C2=A0}
> =C2=A0
> -bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const
> struct path *path)
> -{
> -	struct dentry *dentry =3D path->dentry;
> -	int res;
> -
> -	/* xattr.whiteouts must be a directory */
> -	if (!d_is_dir(dentry))
> -		return false;
> -
> -	res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUTS,
> NULL, 0);
> -	return res >=3D 0;
> -}
> -
> =C2=A0/*
> =C2=A0 * Load persistent uuid from xattr into s_uuid if found, or store a
> new
> =C2=A0 * random generated value in s_uuid and in xattr.
> @@ -811,20 +818,17 @@ bool ovl_init_uuid_xattr(struct super_block
> *sb, struct ovl_fs *ofs,
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> -bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path
> *path,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum ovl_xattr ox)
> +char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path
> *path,
> +			=C2=A0=C2=A0 enum ovl_xattr ox)
> =C2=A0{
> =C2=A0	int res;
> =C2=A0	char val;
> =C2=A0
> =C2=A0	if (!d_is_dir(path->dentry))
> -		return false;
> +		return 0;
> =C2=A0
> =C2=A0	res =3D ovl_path_getxattr(ofs, path, ox, &val, 1);
> -	if (res =3D=3D 1 && val =3D=3D 'y')
> -		return true;
> -
> -	return false;
> +	return res =3D=3D 1 ? val : 0;
> =C2=A0}
> =C2=A0
> =C2=A0#define OVL_XATTR_OPAQUE_POSTFIX	"opaque"
> @@ -837,7 +841,6 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs,
> const struct path *path,
> =C2=A0#define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
> =C2=A0#define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
> =C2=A0#define OVL_XATTR_XWHITEOUT_POSTFIX	"whiteout"
> -#define OVL_XATTR_XWHITEOUTS_POSTFIX	"whiteouts"
> =C2=A0
> =C2=A0#define OVL_XATTR_TAB_ENTRY(x) \
> =C2=A0	[x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> @@ -854,7 +857,6 @@ const char *const ovl_xattr_table[][2] =3D {
> =C2=A0	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
> =C2=A0	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> =C2=A0	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUT),
> -	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUTS),
> =C2=A0};
> =C2=A0
> =C2=A0int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry
> *upperdentry,

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a fiendish overambitious jungle king with a robot buddy named=20
Sparky. She's a radical Bolivian hooker who inherited a spooky stately=20
manor from her late maiden aunt. They fight crime!=20

