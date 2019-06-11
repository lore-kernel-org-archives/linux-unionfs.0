Return-Path: <dwalsh@redhat.com>
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect
 defaults
References: <20190607010431.11868-1-mcoffin13@gmail.com>
 <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
 <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
 <CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
 <CAJfpegvy-Vfc6AEP7+=VfUtfL4izY8AzgoUdvqP4PHnLDEQhNg@mail.gmail.com>
 <20190610184043.GD25290@redhat.com> <20190610184553.GE25290@redhat.com>
 <CAJfpegvrOy3yBpu1AVBFyjdXBNM44k4gSqQ0F2npBG8wH8cUeg@mail.gmail.com>
 <20190611130932.GA28835@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <cb363beb-9b2e-1d20-ca46-cba7724ec648@redhat.com>
Date: Tue, 11 Jun 2019 17:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <20190611130932.GA28835@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Matt Coffin <mcoffin13@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Nalin Dahyabhai <nalin@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 6/11/19 9:09 AM, Vivek Goyal wrote:
> On Tue, Jun 11, 2019 at 02:37:34PM +0200, Miklos Szeredi wrote:
>> On Mon, Jun 10, 2019 at 8:45 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Mon, Jun 10, 2019 at 02:40:43PM -0400, Vivek Goyal wrote:
>>>> On Sun, Jun 09, 2019 at 09:14:38PM +0200, Miklos Szeredi wrote:
>>>>> On Sat, Jun 8, 2019 at 8:47 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>
>>>>>> And then every time that a feature needs to be turned off for some reason
>>>>>> that also needs to be taken into account.
>>>>>> IOW, I advise against diving into this mess. You have been warned ;-)
>>>>> Also a much more productive direction would be to optimize building
>>>>> the docker image based on the specific format used by overlayfs for
>>>>> readirect_dir/metacopy.
>>>>>
>>>>> To me it seems like a no-brainer, but I don't know much about docker, so...
>>>> [ cc Daniel Walsh]
>>>>
>>>> Hi Miklos,
>>>>
>>>> Can you elaborate a bit more on what docker/container-storoage and do
>>>> here to expedite image generation with redirect_dir/metacopy enabled.
>>>>
>>>> They can't pack these xattrs in image because image will not be portable.
>>>> It will be overlayfs specific and can't be made to work on target without
>>>> overlayfs.
>>> Are you referring to apps being able to traverse lower layers and do
>>> the redirect_dir and metacopy resoltion as kernel does. To me that process
>>> is not trivial. Having a library might help with adoption though.
>> AFAICS what happens when generating a layer is to start with a clean
>> upper layer, do some operations, then save the contents of the upper
>> layer.  If redirect or metacopy is enabled, then the contents of the
>> upper layer won't be portable.  So need to do something like this:
>>
>> traverse(overlay_dir, upper_dir, target_dir)
>> {
>>     iterate name for entries in $upper_dir {
>>         if ($name is non-directory) {
>>             copy($overlay_dir/$name, $target_dir/$name)
>>         } else if ($name is redirect) {
>>             copy-recursive($overlay_dir/$name, $target_dir/$name)
>>         } else {
>>             copy($overlay_dir/$name, $target_dir/$name)
>>             traverse($overlay_dir/$name, $upper_dir/$name, $target_dir/$name)
>>         }
>>     }
>> }
>>
>> Basically: traverse the *upper layer* but copy files and directories
>> from the *overlay*.  Does that make sense?
> [ cc nalin ]
>
> Aha... This makes sense to me. This does away with need of separate
> library or user space tool and hopefully its faster than naivediff
> interface. 
>
> Dan, Nalin, what do you think about above idea.
>
> Thanks
> Vivek

This is something we would add to containers/storage?
