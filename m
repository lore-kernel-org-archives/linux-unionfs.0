MIME-Version: 1.0
In-Reply-To: <CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com>
References: <20181031111038.20570-1-amir73il@gmail.com>
	<CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
	<20181031121920.GF23439@veci.piliscsaba.redhat.com>
	<CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
	<CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com>
Date: Wed, 31 Oct 2018 13:37:37 +0100
Message-ID: <CAJfpegsePKZnNe_5OV4D-Y23Ui3_MAytf-rYEFxXwxypfpuzdg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 1:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>>>                         config->redirect_mode = match_strdup(&args[0]);
>>>                         if (!config->redirect_mode)
>>>                                 return -ENOMEM;
>>> +
>>> +                       /* "redirect_dir=off" implies "metacopy=off" */
>>> +                       if (strcmp(config->redirect_mode, "off") == 0 ||
>>> +                           strcmp(config->redirect_mode, "nofollow") == 0)
>>> +                               config->metacopy = false;
>>
>> This look completely counter to the 'strict' behavior definition.
>> If user specified metacopy=on, we are not allowed to end up with metacopy=off.
>
> What about "metacopy=on,metacopy=off"?
>
> What I'm saying is that "metacopy=on,redirect_dir=off" should be
> exactly equivalent to the above, if taking the implicit disable rule
> into account.

In other words: it's a nonsense combination of options, just like the
former.  If documented, then I don't think this would cause problems.

Thanks,
Miklos
