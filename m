Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF540E7D0AB
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjIUU4d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjIUUen (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 16:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA7489D9E
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695318021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGefNxv1yd0BzICQaWLUZmaFcz/PuZWoohN98lo6Wd4=;
        b=TSMYGs1ZSleOhu4wzC5HBeAIA37AuDONOQOt9ULTBB6Y4HK/auQmgCPf5IhA85D+TQ8TIx
        YxUYcMrZ7jdYNgATRgHq/exCeSPlVVYQPD/46ibdM4v4cAsKGLroRj7aC93K2v3GIDNRkd
        w9Mc5EyK567ldTZi+oMOGbVI5B+jvRk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-BCpVCVg0NYGzk_yTvspiQg-1; Thu, 21 Sep 2023 11:26:56 -0400
X-MC-Unique: BCpVCVg0NYGzk_yTvspiQg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-274a43ef967so924415a91.3
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 08:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695310012; x=1695914812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGefNxv1yd0BzICQaWLUZmaFcz/PuZWoohN98lo6Wd4=;
        b=kDEtLsxOhQcFxup94POE6LBPddkZbKLLBuibb7V0VDN76JhVHQd2FiGCUThAmkmCN8
         ro1KA4PPwxF27N35r4jXY7JzWx8FZ38Av8e7vPvYGpy7tncAXvpi3pdZW1lyqzO1L8SD
         UN2kWRe6tLg2HDiKYx1Nar7MxGvorVQdad+zMVtEkDahqZ4jUVhxV/L/YKZqxphIzLS0
         J+Itsgkw7xhF9+3uP4lR7G/6QWUvfibrI5sCWPyCqILvu3YIkkfAaoaceyWZMpOrnuLd
         Tp94R6lRTfPG9TVJWAvJmFUqobu5L+ybSsb+3buj77iCqV1x/0xSL0MKxakz6Ylicst+
         aNgw==
X-Gm-Message-State: AOJu0YwREUCS5s6GhkOkTLySh6jDkaK92Sw6t9U2SRfhKHAtZxD7tNAq
        flHbvqNxO9TGNrBUvAfHAjAFiQUbRUzHWNX4S+nFltcYJjE12eG/A5XCAlXSTABkk7a9FTAvHAF
        vB1QLsE0Ghaa4nHblOysPb8oQFNQjSoVuHi23j7Y=
X-Received: by 2002:a17:90a:4f0b:b0:267:ffcf:e9e3 with SMTP id p11-20020a17090a4f0b00b00267ffcfe9e3mr5877481pjh.46.1695310012394;
        Thu, 21 Sep 2023 08:26:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEX0kiCzjc0LbZSHpkY7QKTmYoqEe2yD0jDAiFR+PxuUVq0MlWDxrFuGdyfhW6d9hOc/EoUQw==
X-Received: by 2002:a17:90a:4f0b:b0:267:ffcf:e9e3 with SMTP id p11-20020a17090a4f0b00b00267ffcfe9e3mr5877463pjh.46.1695310012074;
        Thu, 21 Sep 2023 08:26:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090ad48c00b0026b45fb4443sm3271168pju.4.2023.09.21.08.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 08:26:51 -0700 (PDT)
Date:   Thu, 21 Sep 2023 23:26:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/2] common: add helper _require_chattr_inherit
Message-ID: <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230921143102.127526-1-amir73il@gmail.com>
 <20230921143102.127526-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921143102.127526-2-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 21, 2023 at 05:31:01PM +0300, Amir Goldstein wrote:
> Similar to _require_chattr, but also checks if an attribute is
> inheritted from parent dir to children.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 1618ded5..00cfd434 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4235,23 +4235,57 @@ _require_test_lsattr()
>  		_notrun "lsattr not supported by test filesystem type: $FSTYP"
>  }
>  
> +_check_chattr_inherit()
> +{
> +	local attribute=$1
> +	local path=$2
> +	local inherit=$3

As I understand, this function calls _check_chattr_inherit, so it will
return zero or non-zero to clarify if $path support $attribute inheritance.
...

> +
> +	touch $path
> +	$CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
> +	local ret=$?
> +	if [ -n "$inherit" ]; then
> +		touch "$path/$inherit"
> +	fi

... but looks like it doesn't, it only create a $inherit file, then let the
caller check if the $attribute is inherited.

I think that's a little confused. I think we can name the function as
_check_chattr() and the 3rd argument $inherit as a bool variable, to
decide if we check inheritance or not.

Or you'd like to have two functions _check_chattr and _check_chattr_inherit,
_check_chattr_inherit calls _check_chattr then keep checking inheritance.

What do you think?

Thanks,
Zorro

> +	$CHATTR_PROG "-$attribute" $path > $tmp.chattr 2>&1
> +	if [ "$ret" -ne 0 ]; then
> +		_notrun "file system doesn't support chattr +$attribute"
> +	fi
> +	cat $tmp.chattr >> $seqres.full
> +	rm -f $tmp.chattr
> +	return $ret
> +}
> +
>  _require_chattr()
>  {
>  	if [ -z "$1" ]; then
>  		echo "Usage: _require_chattr <attr>"
>  		exit 1
>  	fi
> -	local attribute=$1
> +	_check_chattr_inherit $1 $TEST_DIR/syscalltest
> +}
>  
> -	touch $TEST_DIR/syscalltest
> -	chattr "+$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
> -	local ret=$?
> -	chattr "-$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
> -	if [ "$ret" -ne 0 ]; then
> -		_notrun "file system doesn't support chattr +$attribute"
> +_require_chattr_inherit()
> +{
> +	if [ -z "$1" ]; then
> +		echo "Usage: _require_chattr_inherit <attr>"
> +		exit 1
>  	fi
> -	cat $TEST_DIR/syscalltest.out >> $seqres.full
> -	rm -f $TEST_DIR/syscalltest.out
> +	local attribute=$1
> +	local testdir="$TEST_DIR/chattrtest"
> +	mkdir -p $testdir
> +	_check_chattr_inherit $attribute $testdir testfile || \
> +		return
> +
> +	local testfile="$TEST_DIR/chattrtest/testfile"
> +	local lsattrout=($($LSATTR_PROG $testfile 2>> $seqres.full))
> +	echo ${lsattrout[*]} >> $seqres.full
> +	echo ${lsattrout[0]} | grep -q $attribute || \
> +		_notrun "file system doesn't inherit chattr +$attribute"
> +
> +	$CHATTR_PROG "-$attribute" $testfile >> $seqres.full 2>&1
> +	rm -f $testfile
> +	rmdir $testdir
>  }
>  
>  _get_total_inode()
> -- 
> 2.34.1
> 

