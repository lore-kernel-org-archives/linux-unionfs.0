MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
References: <20181031111038.20570-1-amir73il@gmail.com>
	<CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
	<20181031121920.GF23439@veci.piliscsaba.redhat.com>
	<CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
Date: Wed, 31 Oct 2018 13:35:38 +0100
Message-ID: <CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 1:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Oct 31, 2018 at 2:19 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

> My 'strict' patch did not try to deal with implicitly enabling redirect_dir
> Vivek posted a different patch to deal with that.

What I mean, is that sections of your patch dealing with the
redirect_dir conflict and sections of Vivek's patch dealing with
_enforce are completely unnecessary if we just define the rules of
implicit enable/disable between metacopy and redirect_dir.

>>                         config->redirect_mode = match_strdup(&args[0]);
>>                         if (!config->redirect_mode)
>>                                 return -ENOMEM;
>> +
>> +                       /* "redirect_dir=off" implies "metacopy=off" */
>> +                       if (strcmp(config->redirect_mode, "off") == 0 ||
>> +                           strcmp(config->redirect_mode, "nofollow") == 0)
>> +                               config->metacopy = false;
>
> This look completely counter to the 'strict' behavior definition.
> If user specified metacopy=on, we are not allowed to end up with metacopy=off.

What about "metacopy=on,metacopy=off"?

What I'm saying is that "metacopy=on,redirect_dir=off" should be
exactly equivalent to the above, if taking the implicit disable rule
into account.


>> @@ -548,6 +553,12 @@ static int ovl_parse_opt(char *opt, stru
>>
>>                 case OPT_METACOPY_ON:
>>                         config->metacopy = true;
>> +
>> +                       /* "metacopy=on" implies "redirect_dir=on" */
>> +                       kfree(config->redirect_mode);
>> +                       config->redirect_mode = kstrdup("on", GFP_KERNEL);
>> +                       if (!config->redirect_mode)
>> +                               return -ENOMEM;
>>                         break;
>>
>
> Helper please. from my "deprecated upper fs" v1 patch:

Yeah, definitely want that one.

Thanks,
Miklos
