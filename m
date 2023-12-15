Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6116418;
	Fri, 15 Dec 2023 09:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2U8QJLL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d336760e72so3505205ad.3;
        Fri, 15 Dec 2023 01:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702632680; x=1703237480; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K7iqJF7ogXiJBCw5tuXu9i0pLwH3sdbIqBd0aocB1+s=;
        b=P2U8QJLLLePTpMV9KQnueD01+3Zui9+7X2Ta6swUQxess4Y2BBQFKJtUq8Lf+xUWTd
         zjuuO3jM+NelFgpTUnO0fRO17sqpDYqImyLDFUL31sgWQuLqafaRgaS0o1FITp4OpaMS
         qfRHTaImVmuIhouWAk0Nt7+6jIunSszN2Zhehy4Zn9PGPDv2BoPSQJ4MJ8626uiDoVyV
         quWYNUkaClTEh1X96/Y/n/RSzc5/JDUpfHxlkaBfd8bW2fJb5R+P5u/7QrSzz7qku9vp
         W7SJykVSLixEVqZdW65FELAtZ21bpIeWLIwkQY95vas53IZXOBy8nMBrMjXb4Ca8IUNC
         zFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702632680; x=1703237480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7iqJF7ogXiJBCw5tuXu9i0pLwH3sdbIqBd0aocB1+s=;
        b=ht+FX0zuzSKTfdmc6xUlx2GpEK/E+cYqXO+2nv7u4WPqFfC8M7daKt9hLEtGyfQaWL
         3nS4KU0ZN5LzljVZ3enrTapoDlRf+uqXdmVKhr1DUHqfPsF77K97E7P7RjCiwnNSEZNw
         pv0KBTbZiJQ10uqp7KyVXa8uY2LRIz5B9iKtxj37i8h+PodgRGlOOHP2WAOt+OlDj9pO
         9/UKdkd42RI617XUH3ruBrIEmmOGmYWUwVZDs6whaJC8X8E27PQlUjxHMox7yeDC4kwH
         xitNBQuWKSrO/8dlDhSIafEuz2jzFDi+sSTO0Hev9l+Cger5ToUECZnlb+7LKL7nQRIA
         wQIQ==
X-Gm-Message-State: AOJu0YxePgjogFbGuUuL+C/OOIkP713GSXbp/1j57pg2gjqHCfUXwGng
	IgCS/1COcJ2Wph8QZJ3/rqQ=
X-Google-Smtp-Source: AGHT+IEZxbAiNkrXoxH0YushmR4Mkme/ry8WkVfrkB59YyIn2OzA8qVJsL9ZsiYSCrzPYA4/EuE6oA==
X-Received: by 2002:a17:902:654a:b0:1d3:5b35:543a with SMTP id d10-20020a170902654a00b001d35b35543amr3363812pln.109.1702632680375;
        Fri, 15 Dec 2023 01:31:20 -0800 (PST)
Received: from [10.0.2.15] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b001d0ce267eaesm13859572plg.250.2023.12.15.01.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Dec 2023 01:31:20 -0800 (PST)
Message-ID: <ffc20839-03a6-4f20-82ae-8707b4b9752b@gmail.com>
Date: Fri, 15 Dec 2023 18:31:18 +0900
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] overlayfs.rst: fix ReST formatting
To: Amir Goldstein <amir73il@gmail.com>
Cc: bagasdotme@gmail.com, brauner@kernel.org, linux-doc@vger.kernel.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
 Akira Yokosawa <akiyks@gmail.com>
References: <20231213123422.344600-3-amir73il@gmail.com>
 <c6c49fd7-2197-48b9-8203-ee5f4634b683@gmail.com>
 <CAOQ4uxj_ikEdF-d3s_S7OGUDk1duUXzYqvB0BkyzFNgrCXYf=Q@mail.gmail.com>
Content-Language: en-US
From: Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <CAOQ4uxj_ikEdF-d3s_S7OGUDk1duUXzYqvB0BkyzFNgrCXYf=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Amir,

On 2023/12/15 17:00, Amir Goldstein wrote:
> On Fri, Dec 15, 2023 at 4:07 AM Akira Yokosawa <akiyks@gmail.com> wrote:
>>
>> Hi,
>>
>> On Wed, 13 Dec 2023 14:34:22 +0200, Amir Goldstein wrote:
>>> Fix some indentation issues and fix missing newlines in quoted text
>>> by converting quoted text to code blocks.
>>>
>>> Unindent a) b) enumerated list to workaround github displaying it
>>> as numbered list.
>>
>> I don't think we need to work around github's weird behavior around
>> enumerated lists.  What matters for us is what Sphinx (+ our own
>> extensions) ends up generating.
>>
>> The corresponding html page rendered by Sphinx is at:
>> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#permission-model
>>
>> It does not look perfect, but at least it preserves enumeration by
>> number and alphabet.
>>
> 
> ok.
> 
>> I'd suggest reporting github about the minor breakage of their
>> rst renderer.
>>
>> Further comments below:
>>
>>>
>>> Reported-by: Christian Brauner <brauner@kernel.org>
>>> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  Documentation/filesystems/overlayfs.rst | 63 +++++++++++++------------
>>>  1 file changed, 32 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
>>> index 926396fdc5eb..a36f3a2a2d4b 100644
>>> --- a/Documentation/filesystems/overlayfs.rst
>>> +++ b/Documentation/filesystems/overlayfs.rst
>>> @@ -118,7 +118,7 @@ Where both upper and lower objects are directories, a merged directory
>>>  is formed.
>>>
>>>  At mount time, the two directories given as mount options "lowerdir" and
>>> -"upperdir" are combined into a merged directory:
>>> +"upperdir" are combined into a merged directory::
>>>
>>>    mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
>>>    workdir=/work /merged
>>> @@ -174,10 +174,10 @@ programs.
>>>  seek offsets are assigned sequentially when the directories are read.
>>>  Thus if
>>>
>>> -  - read part of a directory
>>> -  - remember an offset, and close the directory
>>> -  - re-open the directory some time later
>>> -  - seek to the remembered offset
>>> +- read part of a directory
>>> +- remember an offset, and close the directory
>>> +- re-open the directory some time later
>>> +- seek to the remembered offset
>>
>> To my eyes, unindent spoils the readability of this file as pure
>> plain text.  Please don't do this.
>>
> 
> Ok. I see what you mean.
> I restored a single space indent.
> I don't see why double space is called for and it is inconsistent
> with indentation in the rest of the doc.
> 
>>>
>>>  there may be little correlation between the old and new locations in
>>>  the list of filenames, particularly if anything has changed in the
>>> @@ -285,21 +285,21 @@ Permission model
>>>
>>>  Permission checking in the overlay filesystem follows these principles:
>>>
>>> - 1) permission check SHOULD return the same result before and after copy up
>>> +1) permission check SHOULD return the same result before and after copy up
>>>
>>> - 2) task creating the overlay mount MUST NOT gain additional privileges
>>> +2) task creating the overlay mount MUST NOT gain additional privileges
>>>
>>> - 3) non-mounting task MAY gain additional privileges through the overlay,
>>> - compared to direct access on underlying lower or upper filesystems
>>> +3) non-mounting task MAY gain additional privileges through the overlay,
>>> +   compared to direct access on underlying lower or upper filesystems
>>
>> All you need to fix is this adjustment of indent.
>> Don't do other unindents please
>>
> 
> OK. I also fixed the same indents in "Non-standard behavior".
> 
>>>
>>> -This is achieved by performing two permission checks on each access
>>> +This is achieved by performing two permission checks on each access:
>>>
>>> - a) check if current task is allowed access based on local DAC (owner,
>>> -    group, mode and posix acl), as well as MAC checks
>>> +a) check if current task is allowed access based on local DAC (owner,
>>> +group, mode and posix acl), as well as MAC checks
>>>
>>> - b) check if mounting task would be allowed real operation on lower or
>>> -    upper layer based on underlying filesystem permissions, again including
>>> -    MAC checks
>>> +b) check if mounting task would be allowed real operation on lower or
>>> +upper layer based on underlying filesystem permissions, again including
>>> +MAC checks
>>
>> Your workaround harms the readability very badly.
>> Don't break the construct of enumerated (or numbered) list in rst.
>>
> 
> ok.
> 
>> For the specification of enumerated list, please see:
>>
>> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#enumerated-lists
>>
>> If there is a rst parser who fails to recognize some of the defined
>> list structure, fix such a parser please!
>>
>>>
>>>  Check (a) ensures consistency (1) since owner, group, mode and posix acls
>>>  are copied up.  On the other hand it can result in server enforced
>>> @@ -311,11 +311,11 @@ to create setups where the consistency rule (1) does not hold; normally,
>>>  however, the mounting task will have sufficient privileges to perform all
>>>  operations.
>>>
>>> -Another way to demonstrate this model is drawing parallels between
>>> +Another way to demonstrate this model is drawing parallels between::
>>>
>>>    mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,... /merged
>>>
>>> -and
>>> +and::
>>>
>>>    cp -a /lower /upper
>>>    mount --bind /upper /merged
>>> @@ -328,7 +328,7 @@ Multiple lower layers
>>>  ---------------------
>>>
>>>  Multiple lower layers can now be given using the colon (":") as a
>>> -separator character between the directory names.  For example:
>>> +separator character between the directory names.  For example::
>>>
>>>    mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged
>>>
>>> @@ -340,13 +340,13 @@ rightmost one and going left.  In the above example lower1 will be the
>>>  top, lower2 the middle and lower3 the bottom layer.
>>>
>>>  Note: directory names containing colons can be provided as lower layer by
>>> -escaping the colons with a single backslash.  For example:
>>> +escaping the colons with a single backslash.  For example::
>>>
>>>    mount -t overlay overlay -olowerdir=/a\:lower\:\:dir /merged
>>>
>>>  Since kernel version v6.8, directory names containing colons can also
>>>  be configured as lower layer using the "lowerdir+" mount options and the
>>> -fsconfig syscall from new mount api.  For example:
>>> +fsconfig syscall from new mount api.  For example::
>>>
>>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/a:lower::dir", 0);
>>>
>>> @@ -390,11 +390,11 @@ Data-only lower layers
>>>  With "metacopy" feature enabled, an overlayfs regular file may be a composition
>>>  of information from up to three different layers:
>>>
>>> - 1) metadata from a file in the upper layer
>>> +1) metadata from a file in the upper layer
>>>
>>> - 2) st_ino and st_dev object identifier from a file in a lower layer
>>> +2) st_ino and st_dev object identifier from a file in a lower layer
>>>
>>> - 3) data from a file in another lower layer (further below)
>>> +3) data from a file in another lower layer (further below)
>>
>> Ditto.
>>
>>>
>>>  The "lower data" file can be on any lower layer, except from the top most
>>>  lower layer.
>>> @@ -405,7 +405,7 @@ A normal lower layer is not allowed to be below a data-only layer, so single
>>>  colon separators are not allowed to the right of double colon ("::") separators.
>>>
>>>
>>> -For example:
>>> +For example::
>>>
>>>    mount -t overlay overlay -olowerdir=/l1:/l2:/l3::/do1::/do2 /merged
>>>
>>> @@ -419,7 +419,7 @@ to the absolute path of the "lower data" file in the "data-only" lower layer.
>>>
>>>  Since kernel version v6.8, "data-only" lower layers can also be added using
>>>  the "datadir+" mount options and the fsconfig syscall from new mount api.
>>> -For example:
>>> +For example::
>>>
>>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
>>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
>>> @@ -429,7 +429,7 @@ For example:
>>>
>>>
>>>  fs-verity support
>>> -----------------------
>>> +-----------------
>>>
>>>  During metadata copy up of a lower file, if the source file has
>>>  fs-verity enabled and overlay verity support is enabled, then the
>>> @@ -653,9 +653,10 @@ following rules apply:
>>>     encode an upper file handle from upper inode
>>>
>>>  The encoded overlay file handle includes:
>>> - - Header including path type information (e.g. lower/upper)
>>> - - UUID of the underlying filesystem
>>> - - Underlying filesystem encoding of underlying inode
>>> +
>>> +- Header including path type information (e.g. lower/upper)
>>> +- UUID of the underlying filesystem
>>> +- Underlying filesystem encoding of underlying inode
>>
>> Ditto.
>>
> 
> ok, but inconsistent indentation between numbered and bullet list is
> also not nice:
> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#nfs-export

I agree.

> 
> so I kept this indent and I also indented the non-indented numbered lists
> in this section to conform to the rest of the numbered lists in this doc.
> 
> I've pushed the fixes to overlayfs-next.

OK. I'm looking at commit 4552f4b1be08 ("overlayfs.rst: fix ReST formatting").

It looks reasonable to me.
If you'd like, feel free to add

Reviewed-by: Akira Yokosawa <akiyks@gmail.com>

    Regards, Akira

> Kept RVB from Bagas, because your comment about the unindent is
> aligned with Bagas' initial review comment.
> 
> Thanks,
> Amir.
