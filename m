MIME-Version: 1.0
In-Reply-To: <20181101130322.GA15140@redhat.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
	<20181101004813.31349-2-amir73il@gmail.com>
	<20181101130322.GA15140@redhat.com>
Date: Thu, 1 Nov 2018 14:11:36 +0100
Message-ID: <CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 1, 2018 at 2:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Nov 01, 2018 at 02:48:09AM +0200, Amir Goldstein wrote:

>>
>>               case OPT_METACOPY_ON:
>>                       config->metacopy = true;
>> +                     config->strict = true;
>
> I think either ->strict should go in a separate patch or we should have
> a good description in commit message, explaining why ->strict is there
> and how it will impact behavior going forward.

I'm redoing Amir's patches a bit, and at the moment I'm more inclined
to leave this after the merge window, since there are so many subtle
details to deal with.

Back shortly with an updated set.

Thanks,
Miklos
